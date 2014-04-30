#!/bin/bash
export PROJECT_ID=$(cat /tmp/project_id)

BASEDIR=$(dirname $0)

if [ "$DASHING_DIR" == "" ]; then 
    DASHING_DIR=/opt/lpprmd/dashing
fi

if [ ! -d $DASHING_DIR ] || [ ! -d $DASHING_DIR/dashboards ]; then
    echo "$DASHING_DIR is not a valid dashing directory."
    exit 1
fi

SERIES_IDS=$($BASEDIR/series-list.py)

if [ $? -ne 0 ]; then 
    echo "error: $SERIES_IDS"
    exit 1
else
    erb $BASEDIR/templates/project.erb > $DASHING_DIR/dashboards/$PROJECT_ID.erb
    for series_id in $SERIES_IDS; do
        series_name=$(echo $series_id | cut -d";" -f1)
        export MILESTONES_IDS=$(echo $series_id | cut -d";" -f2)
        erb $BASEDIR/templates/series-detailled-dashboard-template.erb > $DASHING_DIR/dashboards/$series_name.erb
    done
fi
