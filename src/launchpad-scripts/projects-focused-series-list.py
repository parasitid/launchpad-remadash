#!/usr/bin/python2
import sys

from os import environ
from launchpadlib.launchpad import Launchpad

CACHE_DIR = "~/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR, version="devel")

series_sumup_func=lambda s:s.name +";"+",".join( map(lambda ms:ms.name, sorted(s.all_milestones, key=lambda ms:ms.is_active)))

try:
    PROJECTS_IDS=environ["PROJECTS_IDS"].split(",")
except KeyError:
    print "Please set the environment variable [PROJECTS_IDS]"
    sys.exit(1)

for project_id in PROJECTS_IDS:
    try :
        print project_id + "," + LAUNCHPAD.projects[project_id].development_focus.name
    except KeyError:
        pass
