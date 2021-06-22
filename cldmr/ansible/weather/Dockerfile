FROM python:3.9.5-alpine3.13
WORKDIR /app
COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt
COPY weather.py /app/
ENV APIKEY 0
EXPOSE 8000
ENTRYPOINT ["python", "weather.py"]
