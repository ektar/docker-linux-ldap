#!/usr/bin/env bash

/usr/sbin/sssd -d 10 -f -D

service ssh start

tail -f /var/log/dmesg