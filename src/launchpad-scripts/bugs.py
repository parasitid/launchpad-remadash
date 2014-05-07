#!/usr/bin/python2

from httplib2 import Http
from itertools import groupby, ifilterfalse, ifilter
from launchpadlib.launchpad import Launchpad
from os import environ

import json


CACHE_DIR = "~/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR)
H = Http(".cache")





try:
    PROJECT_ID = environ["PROJECT_ID"]
except KeyError:
    print "Please set the environment variable [PROJECT_ID]"
    exit(1)

PROJECT = LAUNCHPAD.projects[PROJECT_ID]
ALL_TASKS = PROJECT.searchTasks()
ALL_BUGS = filter( lambda t:t.importance != "Wishlist", ALL_TASKS )
ALL_WISHES = filter( lambda t:t.importance == "Wishlist", ALL_TASKS )
FOCUS_SERIES_NAME = PROJECT.development_focus.name

def milestone_name( task ):
    if task is not None and task.milestone is not None:
        return task.milestone.name
    else:
        return "untargeted"


def bugs( project ): 
    return filter( lambda t:t.importance != "Wishlist", project.searchTasks())

def bugs_grouped_by_milestone( project ):
    keyfunc = lambda bug:milestone_name(bug)
    return groupby( sorted( bugs(project), key=keyfunc), key=keyfunc)


def nb_bugs_by_type( bugs, bug_type):
    return len(filter(lambda b:b.importance == bug_type, bugs))

for ms_name, ibugs in bugs_grouped_by_milestone( PROJECT ):
    bugs = list(ibugs)
    fixed = filter( lambda bug:bug.status == 'Fix Committed', bugs )
    unfixed = filter( lambda bug:bug.status != 'Fix Committed', bugs )
    json_payload = json.dumps({
        "title": ms_name, 
        "value": int((len(fixed)*100)/len(bugs)),
        "high": nb_bugs_by_type( unfixed, "High"),
        "medium":nb_bugs_by_type( unfixed, "Medium"),
        "low":nb_bugs_by_type( unfixed, "Low"),
        "undecided":nb_bugs_by_type( unfixed, "Undecided"),
        "auth_token":"YOUR_AUTH_TOKEN"
     })
    
    print json_payload
    (response, content) = H.request("http://localhost:3030/widgets/"+PROJECT_ID+"_bugs_"+ms_name,"POST", body=json_payload)

    
