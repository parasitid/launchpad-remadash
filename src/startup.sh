#!/bin/bash

BASEDIR=$(dirname $0)

echo "PROJECTS_IDS is set to $PROJECTS_IDS" 
echo $PROJECTS_IDS > /tmp/projects_ids
export PROJECTS_IDS

# start services
/usr/sbin/cron
/usr/sbin/sshd

# install and list cron jobs installed in logs
crontab /opt/lpprmd/crontab.txt
crontab -l


# generate the dashboards
/opt/lpprmd/launchpad-scripts/generate-dashboards.sh


# start dashing
cd $BASEDIR/dashing
dashing start >> /tmp/output.log 2>&1 &


# sleeping 5s before updating the first time
sleep 5

# and perform a first update before CRON does its job
/opt/lpprmd/launchpad-scripts/update-widgets.sh

echo "dashing started... tailing logs."
tail -f /tmp/output.log
