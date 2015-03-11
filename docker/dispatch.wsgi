ALLDIRS = ['/opt/kallithea/lib/python2.7/site-packages']

import sys 
import site 
import os

# Remember original sys.path.
prev_sys_path = list(sys.path) 

# Add each new site-packages directory.
for directory in ALLDIRS:
  site.addsitedir(directory)

# Reorder sys.path so new directories at the front.
new_sys_path = [] 
for item in list(sys.path): 
    if item not in prev_sys_path: 
        new_sys_path.append(item) 
        sys.path.remove(item) 
sys.path[:0] = new_sys_path 


os.environ["HGENCODING"] = "UTF-8"
os.environ['PYTHON_EGG_CACHE'] = '/opt/kallithea/.egg-cache'

# sometimes it's needed to set the curent dir
os.chdir('/opt/kallithea/')

import site
site.addsitedir("/opt/kallithea/lib/python2.6/site-packages")

from paste.deploy import loadapp
from paste.script.util.logging_config import fileConfig

fileConfig('/opt/kallithea/production.ini')
application = loadapp('config:/opt/kallithea/production.ini')

