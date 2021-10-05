#!/usr/bin/env python3

import logging as log
import os

import requests

from distutils.version import StrictVersion

from requests.auth import HTTPBasicAuth


registry_url = os.environ.get("REGISTRY_URL", "http://localhost:5000")
auth_user = os.environ.get("REGISTRY_AUTH_USER", None)
auth_pass = os.environ.get("REGISTRY_AUTH_PASS", None)

retentions = {
    'app/calculator': 10,
    'app/jmeter' : 5
}

headers = {"accept": "application/vnd.docker.distribution.manifest.v2+json"}
log.basicConfig(level=os.environ.get("LOGLEVEL", "INFO"))

if auth_user and auth_pass:
    auth = HTTPBasicAuth(auth_user, auth_pass)
else:
    auth = False


def getURL(url):
    url = registry_url + "/v2/" + url
    r = requests.get(url, headers=headers, auth=auth)
    if r.status_code == 200:
        return r.json()
    else:
        raise ValueError("URL request exception: URL: {0}, Code: {1}".format(r.status_code, url))


def getRepositories():
    r = getURL("_catalog")
    return r['repositories']


def getTags(repo):
    r = getURL("{0}/tags/list".format(repo))
    tags = r['tags']
    tags.sort(key=StrictVersion, reverse=True)
    log.debug("[getTags] repo {0}, tags: {1}".format(repo, tags))
    return tags


def deleteTag(repo, tag):
    r = getURL("{0}/manifests/{1}".format(repo, tag))
    manifest = r['config']['digest']
    log.debug("{0}/{1}: digest: {2}".format(repo, tag, manifest))
    url = "{registry_url}/v2/{repo}/manifests/{manifest}".format(registry_url = registry_url,
                                                                 repo = repo,
                                                                 manifest = manifest,
                                                                 )
    r = requests.delete(url, headers=headers, auth=auth)
    if r.status_code == 200:
        log.info("[deleteTag] {0}:{1} deleted".format(repo, tag))
    else:
        log.info("[deleteTag] {0}:{1} DID NOT DELETED. RespCode {2}".format(repo, tag, r.status_code))


if __name__ == "__main__":
    log.info("starting images cleanup")
    repos_raw = getRepositories()
    repos_filtered = []
    for r in repos_raw:
        if r in retentions:
            repos_filtered.append(r)
            log.debug("[main] repo {0} - keep {1} tags".format(r, retentions[r]))

    for repo in repos_filtered:
        tags = getTags(repo)
        if len(tags) > retentions[repo]:
            log.info("[main] deleting tags from {0}".format(repo))
            tags_to_delete = tags[retentions[repo]:]
            if "latest" in tags_to_delete:
                tags_to_delete += tags[retentions[repo] + 1]
            log.info("[main] repo {0}, {1} tags to be deleted".format(repo, len(tags_to_delete)))

        for tag in tags_to_delete:
            deleteTag(repo, tag)


