#!/usr/bin/python2

from httplib2 import Http
from urllib import urlopen
from itertools import groupby, ifilter, ifilterfalse
from launchpadlib.launchpad import Launchpad

import json

CACHE_DIR = "~/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR, version="devel")
H = Http(".cache")


def milestone_title( spec ): 

    milestone_link = spec["milestone_link"]

    if milestone_link:
        res = str(milestone_link)
        return res[res.rfind("/")+1:]
    else:
        return "untargeted"

def retrieve_specifications_json( project ):
    return json.loads( urlopen( project.all_specifications_collection_link).read() )["entries"]

solum = LAUNCHPAD.projects["solum"] 
all_specs = retrieve_specifications_json( solum )

all_sorted_specs = sorted( all_specs, key=lambda spec:milestone_title(spec))

for milestone, ispecs in groupby(all_sorted_specs, key=(lambda spec:milestone_title(spec))):
    specs = list(ispecs)
    nb_of_complete_specs = len( list(ifilter( lambda spec:spec["is_complete"], specs )))
    percentage_of_complete_specs = int(nb_of_complete_specs * 100 / len( specs ))
    uncomplete_specs = list(ifilterfalse( lambda spec:spec["is_complete"], specs ))

    json_payload = json.dumps({
        "title": milestone, 
        "value": percentage_of_complete_specs,
        "essential":len(list( ifilter( lambda spec:spec["priority"] == "Essential", uncomplete_specs ))),
        "high":len(list( ifilter( lambda spec:spec["priority"] == "High", uncomplete_specs ))),
        "medium":len(list( ifilter( lambda spec:spec["priority"] == "Medium", uncomplete_specs ))),
        "low":len(list( ifilter( lambda spec:spec["priority"] == "Low", uncomplete_specs ))),
        "auth_token":"YOUR_AUTH_TOKEN"
     })
    
    print json_payload
    (response, content) = H.request("http://localhost:3030/widgets/"+milestone,"POST", body=json_payload)
    
