#!/usr/bin/python3

import sys
import os
 
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

# total arguments
n = len(sys.argv)

if n != 3:
    usage(f"Incorrect number of arguments ({n-1})")

file1 = read_file(sys.argv[1])
file2 = read_file(sys.argv[2])
diff = []
 
for line in file1:
    if not line in file2 and not "#" in line and len(line.strip()) > 0:
        diff.append(f"<- {line}")

for line in file2:
    if not line in file1 and not "#" in line and len(line.strip()) > 0:
        diff.append(f"-> {line}")

diff.sort(key = lambda x: x.split()[1])
for line in diff:
    print(line)


