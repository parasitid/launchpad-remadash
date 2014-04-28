#!/bin/bash

BASEDIR=$(dirname $0)

# start services
/usr/sbin/cron
/usr/sbin/sshd

#install and list cron jobs installed in logs
crontab /opt/solum-dashboard/crontab.txt
crontab -l

#start dashing
cd $BASEDIR/dashing
dashing start >> /tmp/output.log 2>&1 &

echo "dashing started... tailing logs."
tail -f /tmp/output.log
