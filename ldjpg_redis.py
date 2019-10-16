#!/usr/bin/python
# -*- coding: UTF-8 -*-

import sys
from PIL import Image
import redis
import StringIO

output = StringIO.StringIO()
im = Image.open(sys.argv[1])
im.save(output, format=im.format)
r = redis.StrictRedis(host='localhost')
r.set(sys.argv[2], output.getvalue())
output.close()
#EOF
