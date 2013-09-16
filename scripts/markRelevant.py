#!/usr/bin/python
"""Read the patent ids of all the relevant patents into a list.
   Read the whole list of related pats/apps and mark each as either 1 or 0
     depending on whether it is relevant or not respectively."""

with open("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/relevantPatIds.csv","r") as infd:
  relevantPatApps=infd.read().splitlines()

with open("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/full10kList/relatedList.csv","r") as infd:
  relatedPatApps=infd.read().splitlines()

relevantCount=0
unwantedCount=0
outfd=open("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/full10kList/markRelavant.csv","w")
for pat in relatedPatApps:
  if pat in relevantPatApps:
    line=pat+",relevant\n"
    relevantCount+=1
  else:
    line=pat+",unwanted\n"
    unwantedCount+=1
  outfd.write(line)

outfd.close()

print "Number of relevant pats (of 1069) in current data: "+str(relevantCount)
print "Number of unwanted pats in current data: "+str(unwantedCount)
