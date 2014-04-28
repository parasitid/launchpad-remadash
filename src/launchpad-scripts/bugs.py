#!/usr/bin/python2

from httplib2 import Http
from itertools import groupby, ifilterfalse, ifilter
from launchpadlib.launchpad import Launchpad

import json


CACHE_DIR = "~/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR)
H = Http(".cache")

def milestone_title( milestone_link ): 
    if milestone_link:
        res = str(milestone_link)
        return res[res.rfind("/")+1:]
    else:
        return "untargeted"

def bugs( project ): 
    for task in project.searchTasks():
        yield {
            'milestone' : milestone_title( task.milestone ),
            'importance' : str(task.importance),
#            'assignee' : str(task.assignee.display_name) if task.assignee else "unassagined",
            'status' : str(task.status)
        }

def sorted_bugs( project, keyfunc ):
    return sorted( bugs(project), key=keyfunc)


milestone_keyfunc=(lambda bug:bug['milestone'])

sbugs = sorted_bugs( LAUNCHPAD.projects["solum"], milestone_keyfunc )

def bugsCompletedPercentage( bugs, bug_type):
    total = len(bugs)
    total_for_type = len(list(ifilter(lambda b:b["importance"] == bug_type, bugs)))
    return int((total_for_type*100)/total)

def nb_bugs_by_type( bugs, bug_type):
    return len(list(ifilter(lambda b:b["importance"] == bug_type, bugs)))



for milestone, ibugs in groupby(sbugs, key=milestone_keyfunc):
    bugs = list(ibugs)
    fixed = list(ifilter( lambda bug:bug['status'] == 'Fix Committed', bugs ))
    unfixed = list(ifilterfalse( lambda bug:bug['status'] == 'Fix Committed', bugs ))
    json_payload = json.dumps({
        "title":"bugs " + milestone, 
        "value": int((len(fixed)*100)/len(bugs)),
        "high": nb_bugs_by_type( unfixed, "High"),
        "medium":nb_bugs_by_type( unfixed, "Medium"),
        "low":nb_bugs_by_type( unfixed, "Low"),
        "wishlist":nb_bugs_by_type( unfixed, "Wishlist"),
        "undecided":nb_bugs_by_type( unfixed, "Undecided"),
        "auth_token":"YOUR_AUTH_TOKEN"
     })
    
    print json_payload
    (response, content) = H.request("http://localhost:3030/widgets/bugs_"+milestone,"POST", body=json_payload)

    
