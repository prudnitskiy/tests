# Readme

## Description

This is a test assignement. Tasks performed by this assignement:
- install and configure web server (nginx is used here)
- copy HTML file to webserver root (will be reachable by http://SERVER/web.html)
- enable and configure firewall
- configure remote logging to specified address

Tasks off-scope:
- deployment of server itself (terraform/CDK)
- remote logging server (HUB) configuration

## Requirements

- ansible (2.9 tested)
- server is reachable by SSH with public key authentication
- sufficient permissions set on server (sudo or root)

## How to run

- add desired server address to hosts.ini file 
- run playbook with: 

    ansible-playbook -i hosts.ini config-server.yml

## Considerations

This ansible playbook was tested on Debian 10. It should work on Debian 8 to 11 and Ubuntu (respective version). Migration to RHEL-based repos is possible but require some changes.

Server configuration added to autostart, please be careful with file changes - you can cut off your access with no option to recover it.

This test assignement is designed to be as simple and visible as possible.

## Room for improvement

- It is possible to use systemd one-shoot job instead of direct command execution. Although, direct command was left for config simplification as systemd require systemd collection installed on config host.
- IPTables config should have more configuration flexibility, but this task is out of this scope
- Firewall configured for IPv4 only as it is more popular. It is simple to add IPv6 support as well.
