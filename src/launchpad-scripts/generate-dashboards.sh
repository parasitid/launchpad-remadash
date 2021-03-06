#!/bin/bash

if [ -f /tmp/projects_ids ]; then 
    export PROJECTS_IDS=$(cat /tmp/projects_ids)
 fi

if [ "$PROJECTS_IDS" == "" ]; then 
    echo "PROJECTS_IDS is undefined. Please set a PROJECTS_IDS env variable corresponding to a list of launchpad projects separated by commas."
    exit 1
fi

BASEDIR=$(dirname $0)

if [ "$DASHING_DIR" == "" ]; then 
    DASHING_DIR=/opt/lpprmd/dashing
fi

if [ ! -d $DASHING_DIR ] || [ ! -d $DASHING_DIR/dashboards ]; then
    echo "$DASHING_DIR is not a valid dashing directory."
    exit 1
fi


PROJECTS_FOCUSED_SERIES=$($BASEDIR/projects-focused-series-list.py)
export FOCUSED_SERIES_IDS=$(echo $PROJECTS_FOCUSED_SERIES | tr ' ' '\n' | cut -d\; -f1 | tr '\n' ';')
erb $BASEDIR/templates/default.erb > $DASHING_DIR/dashboards/default.erb

for PROJECT_ID in $(echo $PROJECTS_IDS | tr ',' ' '); do
    export PROJECT_ID
    SERIES_LIST=$($BASEDIR/series-list.py)

    if [ $? -ne 0 ]; then 
        echo "error: $SERIES_LIST"
        exit 1
    else
        export SERIES_IDS=$(echo $SERIES_LIST | tr ' ' '\n' | cut -d\; -f1 | tr '\n' ';')
        erb $BASEDIR/templates/project.erb > $DASHING_DIR/dashboards/$PROJECT_ID.erb
        for series in $SERIES_LIST; do
            series_id=$(echo $series | cut -d";" -f1)
            export MILESTONES_IDS=$(echo $series | cut -d";" -f2)
            erb $BASEDIR/templates/series-detailled-dashboard-template.erb > $DASHING_DIR/dashboards/${PROJECT_ID}_$series_id.erb
        done
    fi
done
