#!/bin/bash
export PROJECT_ID=$(cat /tmp/project_id)

BASEDIR=$(dirname $0)

$BASEDIR/series.py >> /tmp/output.log 2>&1 &
$BASEDIR/bugs.py >> /tmp/output.log 2>&1 &
$BASEDIR/milestones.py >> /tmp/output.log 2>&1 &

