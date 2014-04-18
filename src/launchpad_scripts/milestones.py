#!/usr/bin/python

from httplib import HTTPConnection
from urllib import urlopen
from itertools import groupby, ifilter, ifilterfalse
from launchpadlib.launchpad import Launchpad

import json


CACHE_DIR = "/home/dashing/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR, version="devel")
DASHING_CONN = HTTPConnection("localhost", 3030)


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


def retrieve_specifications_json( project ):
    return json.loads( urlopen( project.all_specifications_collection_link).read() )


milestone_keyfunc=(lambda bug:bug['milestone'])
fixed_bugs_keyfunc=(lambda bug:bug['status'] == 'Fix Committed')

sbugs = sorted_bugs( LAUNCHPAD.projects["solum"], milestone_keyfunc )

solum = LAUNCHPAD.projects["solum"] 
specs = retrieve_specifications_json( solum )
print len( specs["entries"])

def bugsCompletedPercentage( bugs, bug_type):
    total = len(bugs)
    total_for_type = len(list(ifilter(lambda b:b["importance"] == bug_type, bugs)))
    return int((total_for_type*100)/total)

def nb_bugs_by_type( bugs, bug_type):
    return len(list(ifilter(lambda b:b["importance"] == bug_type, bugs)))



for milestone, ibugs in groupby(sbugs, key=milestone_keyfunc):
    bugs = list(ibugs)
    fixed = list(ifilter( fixed_bugs_keyfunc, bugs ))
    unfixed = list(ifilterfalse( fixed_bugs_keyfunc, bugs ))
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
               
#    DASHING_CONN.request("POST", "/widgets/bugs_"+milestone , json_payload)
#    response = DASHING_CONN.getresponse()
    
