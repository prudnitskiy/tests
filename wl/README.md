# WL Test assignement

This is a test docker registry kubernetes deployment. It contains:
- replicated docker registry with persisted storage
- docker registry cache
- ingress rule with basic auth (nginx-ingress is used as an ingress)
- docker-registry GC batch job (runs once a day)

:warning: Please do not use it as a production solution as it contains some weak points intentionally left.

