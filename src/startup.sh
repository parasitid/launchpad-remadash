#!/bin/bash

BASEDIR=$(dirname $0)

echo "PROJECT_ID is set to $PROJECT_ID" 
echo $PROJECT_ID > /tmp/project_id
export PROJECT_ID

# start services
/usr/sbin/cron
/usr/sbin/sshd

# install and list cron jobs installed in logs
crontab /opt/lpprmd/crontab.txt
crontab -l

# start dashing
cd $BASEDIR/dashing
dashing start >> /tmp/output.log 2>&1 &


# sleeping 5s before updating the first time
sleep 5

# and perform a first update before CRON does its job
/opt/lpprmd/launchpad-scripts/update.sh

echo "dashing started... tailing logs."
tail -f /tmp/output.log
