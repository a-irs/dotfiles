#!/usr/bin/env python3

import urllib.request
import re
import sys

MAX_RESULTS = 15


class Dict:

    def __init__(self):
        self.inputLanguage = "de"
        self.outputLanguage = "en"
        self.input = []
        self.output = []

    def setInputLanguage(self, lang):
        self.inputLanguage = lang

    def setOutputLanguage(self, lang):
        self.outputLanguage = lang

    def getResponse(self, word):
        lang = self.inputLanguage + self.outputLanguage
        url = "http://" + lang + ".dict.cc/?s=" + word
        req = urllib.request.Request(url, None, {'User-agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0'})
        f = urllib.request.urlopen(req)
        self.Response = str(f.read(), encoding='utf8')

    # Find 'var c1Arr' and 'var c2Arr'
    def parseResponse(self):

        self.inputWords = []
        self.outputWords = []

        engLine = deLine = ""

        lines = self.Response.split("\n")

        for l in lines:
            if l.find("var c1Arr") >= 0:
                engLine = l
            elif l.find("var c2Arr") >= 0:
                deLine = l

        if not engLine or not deLine:
            return False

        else:
            pattern = "\"[^,]+\""

            # Return list of matching strings
            self.inputWords = re.findall(pattern, engLine)
            self.outputWords = re.findall(pattern, deLine)

    def printResults(self):
        if not self.inputWords or not self.outputWords:
            print("No results.")

        else:
            # Get minumum number of both eng and de
            minWords = len(self.inputWords) if len(self.inputWords) <= len(self.outputWords) else len(self.outputWords)

            # Is it more than MAX_RESULTS?
            minWords = minWords if minWords <= MAX_RESULTS else MAX_RESULTS

            # Find biggest word in first col
            length = 0
            for w in self.inputWords[:minWords]:
                length = length if length > len(w) else len(w)

            for i in range(0, minWords):
                if self.inputWords[i] == "\"\"":
                    continue
                print(self.inputWords[i].strip('"') + "." * (length - len(self.inputWords[i].strip("\"")) + 15) + self.outputWords[i].strip('"'))


if __name__ == "__main__":

    if len(sys.argv) < 4:
        print("USAGE:\n$ dict.py \"input language (e.g. DE for German)\" \"output language e.g. EN for English)\" \"word\"")
    else:
        # Concat all arguments into one word (urlencoded space)
        expression = ""

        inputFromSysArgv = sys.argv[1].upper()
        outputFromSysArgv = sys.argv[2].upper()

        for index in range(3, len(sys.argv)):
            expression += sys.argv[index] + " "

        print(inputFromSysArgv + " to " + outputFromSysArgv + ": " + expression + "\n")

        expression = urllib.parse.quote(expression)

        myDict = Dict()
        myDict.setInputLanguage(inputFromSysArgv)
        myDict.setOutputLanguage(outputFromSysArgv)
        myDict.getResponse(expression)
        myDict.parseResponse()
        myDict.printResults()
