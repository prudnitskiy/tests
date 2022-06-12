# Documentation

## Preface

This chart is designed to be a part of technical assignement. It is designed to be as simple and automated as possible, but it contains some flaws. This helm chart should not be used in production.

## Building an image

To build the image please run `docker build -t {NAME}:{VERSION} .` in the root of project. 

Image should be pushed to target repo by running `docker push {NAME}:{VERSION}`. Please build image before running tests because this image is private. Default value considered by helm chart is 0.1.0

## Installing helm chart

Please verify helm values. You can get them by running `helm show values hiring-test-helm-chart`. The most of the values have reasonable default. `image.repository` and `image.tag` should be set according to image name set on previous step. To install the chart please use those commands:

    helm dependency update hiring-test-helm-chart
    helm install --generate-name hiring-test-helm-chart

### Private docker repository

If you want to use private docker repository -- please create a secret as it is described [here](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-secret-by-providing-credentials-on-the-command-line).

You can pass secret name with `--set imagePullSecrets[0].name={DOCKER_SECRET_NAME}` argument in helm install step.

## Accessing service

The service is not published by default but it is reachable from the inside cluster (ClusterIP type). You can publish it using ingress or connect to it via kubectl port-forward. Helm will display exact instruction during the installation

## Possible issues

Helm is not deleting PV and PVCs of PostgreSQL during uninstallation, but secrets will be deleted. If you uninstall the chart and install it back - you'll lose access to your databases because password is crated during chart install. Options to mitigate this problem:
- backup the secret and create it back _before_ you install helm chart. Ensure helm release name is the same because secret name depends on helm release name.
- delete PVC after helm chart uninstall. You'll lose content of the database in this case.
- change helm release name during install. In this case new database will be created.
