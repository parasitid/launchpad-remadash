#!/bin/bash

BASEDIR=/opt/solum-dashboard

# bundle dashing
cd $BASEDIR/dashing
bundle

#install crontab
mkdir -p /var/spool/cron/
cp $BASEDIR/crontab /var/spool/cron/root
