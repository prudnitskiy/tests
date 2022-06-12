FROM python:3.8-slim-buster
LABEL "Maintainer" "Pavel Rudnitskiy <me@prudnitskiy.pro>"

# psycopg2 requirement
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/
ADD app /app/
ADD requirements.txt /app/

RUN pip install -r requirements.txt

EXPOSE 8080/tcp
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "app.wsgi:application"]
