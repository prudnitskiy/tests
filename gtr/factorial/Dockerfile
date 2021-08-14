FROM python:3.9.5-alpine3.13
WORKDIR /app
COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt
COPY app.py /app/
EXPOSE 5000
ENTRYPOINT ["/usr/local/bin/python", "/app/app.py"]
