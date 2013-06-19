#! /usr/bin/python
"""Verify maxent and svm results"""

__author__="vsubhashini"

def checkResults(filename):
  """Check if original and assigned class results"""
  count=0
  svmCorrect=0.0
  maxentCorrect=0.0
  with open(filename, "r") as infd:
    for line in infd:
      if(count==0):
        count+=1
        continue
      line=line.split(",")
      orig=line[0].strip()
      maxent=line[1].strip()
      svm=line[3].strip()
      print orig, maxent, svm
      if(maxent==orig):
        maxentCorrect+=1
      if(svm==orig):
        svmCorrect+=1
  print maxentCorrect
  print svmCorrect 
  accuracyM=maxentCorrect/200.0
  accuracyS=svmCorrect/200.0
  print "maxent= "+str(accuracyM)
  print "svm= "+str(accuracyS)

def main():
  filename="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/pyAnalysisOutput/maxent-svm-results-orig.csv"
  checkResults(filename)

if __name__=="__main__":
  main()
