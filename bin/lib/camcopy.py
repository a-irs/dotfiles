#!/usr/bin/env python

import sys
import os
import subprocess
from prettytable import PrettyTable
import time
import datetime

def convertLine(line, counter):
    """
    makes a PrettyTable entry with a counter if the line started with "==" (so it was a copied file)
    else just print the line
    returns the new counter value
    """
    if line.startswith('=='):
        number   = '\033[1;35m' + str(counter) + '/' + str(totalFiles)   + '\033[0m'
        percent  = '\033[34m'   + str(int(counter/totalFiles*100)) + '%' + '\033[0m'
        filename = '\033[33m'   + line.replace('=', '').strip()          + '\033[0m'
        table.add_row([number, percent, filename])

        clear()
        print(table)
        if counter == totalFiles:
            end()
        return counter + 1
    elif line.startswith(' '):
        print(line.strip())
    return counter

def clear():
    """
    clears the console
    """
    os.system('cls' if os.name=='nt' else 'clear')

def end():
    """
    prints the end dialog with the total duration of the process and the source/target path
    """
    duration = str(datetime.timedelta(seconds=int(time.time() - startTime)))
    print('\033[1;37m')
    print("done in " + duration)
    print()
    print("source: " + os.path.realpath(sourceDir))
    print("target: " + os.path.realpath(targetDir))
    print()

def initTable():
    """
    inits the PrettyTable with the header lines
    returns the PrettyTable object
    """
    tableNumber  = '\033[1;35m' + "number" + '\033[0m'
    tablePercent = '\033[1;34m' + "percent" + '\033[0m'
    tableFile    = '\033[1;33m' + "file" + '\033[0m'
    table = PrettyTable([tableNumber, tablePercent, tableFile])
    table.align[tableNumber] = "r"
    table.align[tablePercent] = "r"
    table.align[tableFile] = "l"
    return table

def checkArguments():
    """
    checks if the input arguments are valid, else exits
    valid if: two arguments which have to be directories
    """
    if len(sys.argv) < 3:
        print('ERROR! Proper usage: ' + __file__ + ' [SOURCE-DIR] [TARGET-DIR]')
        sys.exit(1)
    elif not os.path.isdir(sys.argv[1]):
        print('ERROR! \'' + sys.argv[1] + '\' is not a valid directory')
        sys.exit(1)
    elif not os.path.isdir(sys.argv[2]):
        print('ERROR! \'' + sys.argv[2] + '\' is not a valid directory')
        sys.exit(1)

def totalFiles(directory):
    """
    returns the total number of files in the given directory
    """
    totalFiles = 0
    for root, dirs, files in os.walk(directory):
        totalFiles += len(files)
    if totalFiles < 1:
        sys.exit(2)
    return totalFiles

checkArguments()
table = initTable()

sourceDir = sys.argv[1]
targetDir = sys.argv[2]

totalFiles = totalFiles(sourceDir)

exiftool = ['exiftool', '-v0', '-r', '-o', '.', '-FileName<DateTimeOriginal', '-d', targetDir + '/%Y/%Y-%m/%Y-%m-%d/%Y%m%d_%H%M%S_%%f%%+c.%%ue', sourceDir]
proc = subprocess.Popen(exiftool, stdout=subprocess.PIPE, universal_newlines=True)
startTime = time.time()

counter = 1
while True:
    line = proc.stdout.readline()
    if line != '':
        counter = convertLine(line, counter)
    else:
        break
