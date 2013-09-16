#!/usr/bin/python
""" For the Related (Relevant vs unwanted pat apps):
    Read the topic model composition file and create 
    a neat dataset for running on R
    We want dataset to be like:
    (ir)relevant topic0prob topic1prob ... topic14prob patentId"""

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
    """Represents a single patent (the distribution of the patent across topics 0 to 14, meta-data)"""
    def __init__(self):
      self.patfile=''
      self.techId=0
      self.relevant=''
      self.dist={} #dictionary {topicNum1: probscore1, topicNum2: probscore2, ...}

  def __init__(self):
    self.patents = {} #dictionary {patfile: TopicDist, ...} 

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

  def getRelevant(self, relevantFile):
    """Get Technology Area for each patent"""
    count=0;
    for line in import_text(relevantFile,','):
      #if count==0:
      #  count+=1
      #  continue
      count+=1
      patfile = line[0] #1 number is the patent-Num
      relev = line[1].strip()
      #print relev
      taid=0
      if relev=="relevant":
        taid = 1
      #print taid
      if(self.patents.get(patfile)==None):
        print "Could not find record for "+patfile
      else: 
        self.patents[patfile].relevant = relev
        self.patents[patfile].techId = taid
      if(count<10):
        print self.patents[patfile].patfile
        print "Relevant: "+relev+" Id: "+str(self.patents[patfile].techId)
        print self.patents[patfile].dist
        print "Done"

  def printTAdist(self, outfile):
    """Write out the relevancy and topic distribution in a datafile"""
    with open(outfile, 'w+') as opfd:
      count=0
      for patfile in self.patents:
        line = self.patents[patfile].relevant
        count+=1
        for i in range(0,numTopics):
          line+=","+str(self.patents[patfile].dist[i])
        line+=","+patfile #added to print patfilenum
        line+="\n"
        if(count<10):
          print self.patents[patfile].patfile
          print line
          print "TA Done"
        opfd.write(line)

  def printReldist(self, outfile):
    """Write out the topic distribution and then relevancy in a datafile"""
    with open(outfile, 'w+') as opfd:
      count=0
      for patfile in self.patents:
        line=str(self.patents[patfile].dist[0])
        count+=1
        for i in range(1,numTopics):
          line+=","+str(self.patents[patfile].dist[i])
        line+=","+self.patents[patfile].relevant
        #line+=","+patfile #added to print patfilenum
        line+="\n"
        if(count<10):
          print self.patents[patfile].patfile
          print line
          print "TA Done"
        opfd.write(line)

def main():
  compositionFile="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/malletdata/outputFiles/relatedPatApps-composition-v1.txt";
  patentFile="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/full10kList/markRelavant.csv";
  #outputFile="../data/pyAnalysisOutput/relPatApp-TopicDist-4R-v1.data";
  outputFile="../data/pyAnalysisOutput/relPatApp-TMdist-4R-v1.data";
  patents=Patents()
  patents.getTopicDists(compositionFile)
  patents.getRelevant(patentFile)
  #patents.printTAdist(outputFile)
  patents.printReldist(outputFile)

if __name__=="__main__":
    main()
