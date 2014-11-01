#!/usr/bin/python

import fileinput
import json
import sys

for line in fileinput.input():
    obj = json.loads(line)

    if obj['event'] == 'end-test':
        if obj['succeeded']:
            sys.stdout.write('\033[32m.')
        else:
            sys.stdout.write('\n')
            error = obj['exceptions'][0]
            sys.stdout.write('\033[31m' + error['reason'] + '\033[0m @ line ' + str(error['lineNumber']))
            sys.stdout.write('\n')
			
sys.stdout.write('\n')