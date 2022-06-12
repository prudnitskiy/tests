# hiring-test

The hiring test consists of an assignment where you work on the containerization of a Django app and write a helm chart for it.

## Delivering the test results

You will need to create a new branch within this project.
All the required changes need to be done within this newly created branch.

When you are done commit and push your changes and open a MR (Merge Request) and let us know via email that you are done with the test.

## Test documentation

You will need to document which steps and/or commands are needed to run your test.\
Please write this documentation within the `DOCS.md` file.

## Containerization of the Django app

You will need to containerize the provided Django app.\
The provided `Dockerfile` needs to be used as a starting point.

Make sure that the required python packages are installed as listed within the `requirements.txt` file.

### Required environment variables

For the Django app to run correctly the following environment variables are required:

- `SECRET_KEY`
- `DEBUG`
- `DATABASE_NAME`
- `DATABASE_USER`
- `DATABASE_PASSWORD`
- `DATABASE_HOST`
- `DATABASE_PORT`

Make sure to set these to the correct values.

### Running database migrations

The following command shows howto run the Django database migrations:

```
python manage.py migrate
```

### Serving the app

The following command shows you howto run the Django app:

```
gunicorn --bind 0.0.0.0:8080 --access-logfile - app.wsgi:application
```

## Helm chart for the Django app

Within the `hiring-test-helm-chart` directory you will find a Helm chart that should be used as a starting point.\
You will need to change this Helm chart so it supports the following requirements:

- The container runs as non-root.
- A Readiness Probe is used.
- A Liveness probe is used.
- The application should be highly available.
- The application should be deployed with zero downtime.
- The Django migrations need to run only once and before the Django app is started.
- Set CPU request to 1 CPU or below.
- Memory limit equals memory requests and they should be set to a sane value.
- PostgreSQL is a dependency for this Helm chart as the Django app requires it.
- Labels should be set according to:
  - https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels

## Minikube

Use [minikube](https://minikube.sigs.k8s.io/) to create a local kubernetes cluster.\
The helm chart should be able to be installed onto the kubernetes cluster using the following command:

```
helm upgrade --install --wait ...
```

The app should then be reachable via the `minikube service` command.
