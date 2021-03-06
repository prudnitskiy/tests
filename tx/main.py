#!/usr/bin/env python3
import logging
import argparse
import random
import time
from kubernetes import client, config
from prometheus_client import start_http_server, Counter


def monkeyLoop(clargs):
    logging.debug("loop started")
    config.load_kube_config()
    v1 = client.CoreV1Api()
    logging.debug("KubeCTL connected")

    while True:
        start = time.monotonic()
        pods = findPods(kclient=v1, namespace=clargs.namespace, annotation=clargs.filter)
        if pods:
            randomSelectedPod = random.randint(0, len(pods) - 1)
            logging.debug("{0} selected as a prey this cycle".format(pods[randomSelectedPod].metadata.name))
            deletePod(kclient=v1, pod=pods[randomSelectedPod], dryRun=clargs.dry_run)
        took = time.monotonic() - start
        left = clargs.timer - took
        prom_epoch.inc()
        if left > 0:
            time.sleep(left)


def findPods(kclient, namespace, annotation=False):
    pods = []
    fselector = "metadata.namespace={0},status.phase=Running".format(namespace)
    if annotation:
        logging.debug("annotation:{0}".format(annotation))
    try:
        ret = kclient.list_pod_for_all_namespaces(watch=False, field_selector=fselector)
    except ApiException as e:
        logging.info("pod list failed: {0}".format(str(e)))
        return False
    for i in ret.items:
        if annotation and i.metadata.annotations:
            if annotation in i.metadata.annotations:
                pods.append(i)
                logging.debug(i.metadata.name)
        if annotation is False:
            pods.append(i)
            logging.debug(i.metadata.name)
    if len(pods) > 0:
        logging.info("{0} candidates filtered to deletion".format(len(pods)))
        return pods
    else:
        return False


def deletePod(kclient, pod, dryRun=False):
    logging.debug("deleting pod {0}".format(pod.metadata.name))
    if dryRun:
        logging.info("dry run set, no changes")
    else:
        try:
            kclient.delete_namespaced_pod(name=pod.metadata.name, namespace=pod.metadata.namespace)
        except ApiException as e:
            logging.info("pod delete failed: {0}".format(str(e)))
            return False
        logging.info("{0}/{1} deleted".format(pod.metadata.namespace, pod.metadata.name))
        prom_killed.labels(pod.metadata.labels).inc()
        return True


if __name__ == '__main__':
    # Config
    parser = argparse.ArgumentParser(description='ChaosMonkey')
    parser.add_argument('--namespace',
                        '-n',
                        type=str,
                        help='namespace',
                        default='default'
                        )
    parser.add_argument('--timer',
                        '-t',
                        type=int,
                        help='length of timer cycle in seconds',
                        default=180)
    parser.add_argument('--filter',
                        '-f',
                        type=str,
                        help='annotation filter',
                        default=False)
    parser.add_argument('--verbose',
                        '-v',
                        help='verbosity level',
                        default='info')
    parser.add_argument('--dry-run',
                        '-d',
                        action="store_true",
                        help='dry run (no changes)',
                        default=False)
    clargs = parser.parse_args()

    logging.basicConfig(format='[%(levelname)s][%(asctime)s]: %(message)s',
                        level=clargs.verbose.upper())

    # Init
    logging.info("Starting up. Namespace: {0}, wakeup every {1} seconds".format(clargs.namespace, clargs.timer))
    if clargs.filter:
        logging.info("annotation filter: {0}".format(clargs.filter))

    start_http_server(8000)

    prom_epoch = Counter('epoch', 'epochs passed since first run')
    prom_killed = Counter('killed', 'pods killed since start', ['labels'])
    monkeyLoop(clargs)
