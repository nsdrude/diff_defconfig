#!/usr/bin/env python3

import sys
import os

# Parse env variables
# IGNORE_TYPE: don't care if driver is =m or =y
f_ignore_type = True if os.getenv('IGNORE_TYPE') else False

def usage(err = ""):
    if err != "":
        print(f"Error: {err}\n")
    print (f"Usage: {sys.argv[0]} <file1> <file1>")
    sys.exit(2)

def read_file(file):
    if not os.path.isfile(file):
        usage(f"File not found '{file}'")
    fileObj = open(file, "r") #opens the file in read mode
    lines = fileObj.read().splitlines() #puts the file into an array
    fileObj.close()
    return lines

def split_lines(file, token):
    newfile = []
    for line in file:
        newfile.extend([line.split(token, 1)[0]])
    return newfile

# total arguments
n = len(sys.argv)

if n != 3:
    usage(f"Incorrect number of arguments ({n-1})")

file1 = read_file(sys.argv[1])
file2 = read_file(sys.argv[2])
diff = []

if f_ignore_type:
    file1 = split_lines(file1, "=")
    file2 = split_lines(file2, "=")

for line in file1:
    if not line in file2 and len(line.strip()) > 0:
        diff.append(f"<- {line}")

for line in file2:
    if not line in file1 and len(line.strip()) > 0:
        diff.append(f"-> {line}")

diff.sort(key = lambda x: x.split()[1])
for line in diff:
    print(line)


