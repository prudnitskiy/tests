# Docker deletion script

This script deletes tags from docker registry. It was designed to work with docker-registry API.

Configuration is provided by setting environment variables:
- LOG_LEVEL - makes logging more versbose. Default is INFO
- REGISTRY_URL - registry URL in `protocol://address:port` format. Default is `http://localhost:5000`
- REGISTRY_AUTH_USER & REGISTRY_AUTH_PASS - set if auth is enabled. Default is unset which means no auth enabled

Retention configuration is hardcoded into the script.

Requirements:
- python-requests

Minimal python version:
- Python3 (tested on Python 3.6.9)

Docker registry supported:
- version 2 is required. Deletion must be enabled
