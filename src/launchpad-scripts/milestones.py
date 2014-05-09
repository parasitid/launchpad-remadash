#!/usr/bin/python2

from httplib2 import Http
from urllib import urlopen
from itertools import groupby, ifilter, ifilterfalse
from launchpadlib.launchpad import Launchpad
from os import environ

import json

CACHE_DIR = "~/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR, version="devel")
H = Http(".cache")

try:
    PROJECT_ID = environ["PROJECT_ID"]
except KeyError:
    print "Please set the environment variable [PROJECT_ID]"
    exit(1)

PROJECT = LAUNCHPAD.projects[PROJECT_ID]

def milestone_name( element ):
    if element is not None and element.milestone is not None:
        return element.milestone.name
    else:
        return "untargeted"

def wishes( project ): 
    class Spec():
        pass

    def to_spec( w ):
       s = Spec()
       s.is_complete = ( w.status == "Fix Committed" )
       # there is no importance set for wishes as "Importance" is used to
       # mark tasks as wishes... considering wishes as Medium
       s.priority = "Medium"
       s.milestone = w.milestone
       return s

    return map(to_spec, project.searchTasks(importance="Wishlist"))

def specs_grouped_by_milestone( project ):
    keyfunc = lambda s:milestone_name(s)
    return groupby(sorted( list(project.all_specifications) + wishes(project), key=keyfunc), key=keyfunc)

for ms_name, ispecs in specs_grouped_by_milestone(PROJECT):
    specs = list(ispecs)
    nb_of_complete_specs = len(filter( lambda s:s.is_complete, specs ))
    percentage_of_complete_specs = int(nb_of_complete_specs * 100 / len( specs ))
    uncomplete_specs = filter( lambda s:not s.is_complete, specs )

    json_payload = json.dumps({
        "title": ms_name, 
        "value": percentage_of_complete_specs,
        "essential":len(filter( lambda s:s.priority == "Essential", uncomplete_specs )),
        "high":len(filter( lambda s:s.priority == "High", uncomplete_specs )),
        "medium":len(filter( lambda s:s.priority == "Medium", uncomplete_specs )),
        "low":len(filter( lambda s:s.priority == "Low", uncomplete_specs )),
        "auth_token":"YOUR_AUTH_TOKEN"
     })
    
    print json_payload
    (response, content) = H.request("http://localhost:3030/widgets/"+PROJECT_ID+"_milestone_"+ms_name,"POST", body=json_payload)
