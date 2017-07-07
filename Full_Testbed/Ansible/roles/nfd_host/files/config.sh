i#!/bin/bash

### This is a script to fix a stupid hostname error
### that prevents the sudo command from returning
### proper results.
###
### It appends the current hostname to the 127.0.0.1
### line in /etc/hosts.
###
### IT MUST BE RUN AS SUDO!
###
### -ARD
hst=$(cat /etc/hostname)
sed -i "/127.0.0.1/ {s/$/ $(cat /etc/hostname)/g}" /etc/hosts
