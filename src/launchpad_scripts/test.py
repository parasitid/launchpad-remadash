from httplib import HTTPConnection
from itertools import groupby, ifilter, ifilterfalse
from launchpadlib.launchpad import Launchpad

import json


CACHE_DIR = "/home/dashing/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR)
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


milestone_keyfunc=(lambda bug:bug['milestone'])
fixed_bugs_keyfunc=(lambda bug:bug['status'] == 'Fix Committed')

sbugs = sorted_bugs( LAUNCHPAD.projects["solum"], milestone_keyfunc )

for milestone, ibugs in groupby(sbugs, key=milestone_keyfunc):
    bugs = list(ibugs)
    fixed = list(ifilter( fixed_bugs_keyfunc, bugs ))
    json_payload = json.dumps({
        "title":"bugs " + milestone, 
        "value": int((len(fixed)*100)/len(bugs)),
        "high":0,
        "essential":0,
        "medium":0,
        "low":0,
        "auth_token":"YOUR_AUTH_TOKEN"
     })
               
    DASHING_CONN.request("POST", "/widgets/bugs_"+milestone , json_payload)
    response = DASHING_CONN.getresponse()
    
