#!/bin/bash

BASEDIR=$(dirname $0)

$BASEDIR/bugs.py >> /tmp/output.log 2>&1
$BASEDIR/milestones.py >> /tmp/output.log 2>&1

