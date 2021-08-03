#!/usr/bin/python3
import sys, os, bash

ROOT = str(bash('git rev-parse --show-toplevel'))
version, build = (int(i) for i in next(
	f for f in os.listdir(ROOT) if f.endswith('.rockspec')
)[7:-9].split('-'))

os.system("git add .")
os.system("git commit -m " + repr(sys.argv[1]))
os.system("git tag")
