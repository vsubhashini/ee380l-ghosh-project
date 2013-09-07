#!/usr/bin/python
""" Read the topic model composition file and create 
    a neat dataset for running on R
    We want dataset to be like:
    techArea topic0prob topic1prob ... topic14prob """

__author__="vsubhashini"

import csv
import re

numTopics=15

def import_text(filename,separator):
  #for line in csv.reader(open(filename), delimiter=separator, quotechar='"', skipinitialspace=True):
  for line in csv.reader(open(filename, 'r'), skipinitialspace=True):
    if line:
      yield line

class Patents:

  class TopicDist:
    """Represents the distribution of the patent across topics 0 to 14"""
    def __init__(self):
      self.patfile=''
      self.techId=0
      self.year=0
      self.filing=0
      self.dist={} #dictionary {topicNum1: probscore1, topicNum2: probscore2, ...}

  def __init__(self):
    self.patents = {} #dictionary {patfile: TopicDist, ...} 
    self.TAinvId={1:"Solar Inverter", 2:"Solar Mounting/Rack", 3:"Solar Monitoring", 4:"Site Assessment"}
    self.TAid={"Solar Inverter":1, "Solar Mounting/Rack":2, "Solar Monitoring":3, "Site Assessment":4}

  def getTechId(self,patTA):
    for ta in self.TAid:
      if ta in patTA:
        return self.TAid[ta]
    print "Incorrect techArea: "+patTA

  def getTopicDists(self, compositionFile):
    """
      composition file has abstract's correlation with suggested topic (in desceding order of corr)
      create a distribution vector for each patent
    """
    filenamePattern = '/(\d+)';
    with open(compositionFile, 'r') as cfid:
      next(cfid) #ignore firstline
      count=0
      for line in cfid:
	line=line.split()
	topicDist = self.TopicDist()
	patfiles=re.findall(filenamePattern, line[1])
	if(len(patfiles)<1):
	  print "Patname not there: "+line
          continue
        count+=1
	topicDist.patfile=str(int(patfiles[0])) #convert to int and then string to remove prepending 0s
        if(len(line) < 32):
          print "Wrong num topics in line: " + line
        for t in range(2, len(line), 2):
	  topicDist.dist[int(line[t])]=float(line[t+1])
        #if(count<10):
        #  print patfiles[0] +" :: "+ str(topicDist.dist)
        self.patents[patfiles[0]]=topicDist

  def getTechAreas(self, patentFile):
    """Get Technology Area for each patent"""
    count=0;
    for line in import_text(patentFile,','):
      if count==0:
	count+=1
	continue
      count+=1
      patfile = line[1] #1 number is the patent-Num
      techArea = line[12].strip()
      year = line[2].strip() #issue date
      filing = line[3].strip()
      #print techArea
      #taid = self.TAid[techArea]
      taid = self.getTechId(techArea)
      #print taid
      if(self.patents.get(patfile)==None):
        print "Could not find record for "+patfile
      else: 
        self.patents[patfile].techId = taid
	self.patents[patfile].year=year[:4]
	self.patents[patfile].filing=filing[:4]
      if(count<10):
        print self.patents[patfile].patfile
        print "TA: "+techArea+" Id: "+str(self.patents[patfile].techId)
        print self.patents[patfile].dist
        print "Done"

  def printTAdist(self, outfile):
    """Write out the techID and topic distribution in a datafile"""
    with open(outfile, 'w+') as opfd:
      count=0
      for patfile in self.patents:
        line = str(self.patents[patfile].techId)
        count+=1
        for i in range(0,numTopics):
          line+=","+str(self.patents[patfile].dist[i])
        line+=","+str(self.patents[patfile].year) #added issue year
        line+=","+str(self.patents[patfile].filing) #added filing year
        line+=","+patfile #added to print patfilenum
        line+="\n"
        if(count<10):
          print self.patents[patfile].patfile
          print line
          print "TA Done"
        opfd.write(line)

def main():
  compositionFile="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/patsApps-composition.txt";
  patentFile="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/exported-patsApps.csv";
  outputFile="../data/pyAnalysisOutput/1kTopicDist4R-recheck.data";
  patents=Patents()
  patents.getTopicDists(compositionFile)
  patents.getTechAreas(patentFile)
  patents.printTAdist(outputFile)

if __name__=="__main__":
    main()
