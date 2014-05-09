#!/usr/bin/python2
import sys

from os import environ
from launchpadlib.launchpad import Launchpad

CACHE_DIR = "~/.launchpadlib/cache/"
LAUNCHPAD = Launchpad.login_anonymously('just testing', 'production', CACHE_DIR, version="devel")

series_sumup_func=lambda s:s.name +";"+",".join( map(lambda ms:ms.name, sorted(s.all_milestones, key=lambda ms:ms.is_active)))

try:
    PROJECT = LAUNCHPAD.projects[environ["PROJECT_ID"]]
    print "\n".join( map(series_sumup_func, filter(lambda s:s.active, PROJECT.series)))
except KeyError:
    print "Please set the environment variable [PROJECT_ID]"
    sys.exit(1)
