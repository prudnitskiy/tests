#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import logging
import os
import sys
from time import sleep
from prometheus_client import Gauge, start_http_server


def handleWeather(apikey):
    current_temperature = False
    url = ("https://api.openweathermap.org/data/2.5/onecall?"
    "lat={lat}&lon={lon}&"
    "exclude=minutely,hourly,daily,alerts&"
    "units=metric&appid={apikey}").format(lat=59.26,
                                          lon=24.45,
                                          apikey=apikey)
    r = requests.get(url)
    if r.status_code == 200:
        current_temperature = r.json()['current']['temp']
        g.set(current_temperature)
    else:
        logging.warning("Can't handle a request, responce code is {0}".format(r.status_code))
    sleep(30)


if __name__ == "__main__":
    g = Gauge('temp', 'Temperature in Tallinn')
    
    if not 'APIKEY' in os.environ or os.environ['APIKEY'] == "0":
        sys.exit("No APIKEY defined, exiting")
    else:
        apikey = os.environ.get("APIKEY")

    logging.warning("starting a metrics server")
    start_http_server(8000)

    while True:
        handleWeather(apikey)
