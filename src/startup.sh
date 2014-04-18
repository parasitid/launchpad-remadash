#!/bin/bash

BASEDIR=$(dirname $0)

#start cron
/etc/init.d/cron start

#start dashing
cd $BASEDIR/dashing
dashing start
