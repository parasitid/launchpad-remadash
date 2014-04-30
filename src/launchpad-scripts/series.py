#!/usr/bin/python2

from httplib2 import Http
from itertools import groupby, ifilterfalse, ifilter
from launchpadlib.launchpad import Launchpad
from os import environ

import json


CACHE_DIR = "~/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR, version="devel")
H = Http(".cache")


PROJECT = LAUNCHPAD.projects[environ["PROJECT_ID"]]

#print PROJECT.get_timeline()

def milestone_title( spec ) :
    milestone = spec.milestone
    if milestone is not None: 
        return milestone.title
    else:
        return "untargeted"


for s in PROJECT.series:
    sorted_specs = sorted( s.all_specifications, key=lambda spec:milestone_title(spec))

    print s.name
    print "   releases"
    for r in s.releases:
        print "      "+r.title
    print "   milestones"
    for m in s.all_milestones: 
        print "      "+m.title
    print "   specifications"

    for sp in s.all_specifications:
        print "      "+sp.name +" -> "+ milestone_title( sp )

    print "---"
    
