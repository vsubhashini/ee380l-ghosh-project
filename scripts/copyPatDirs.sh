#!/bin/bash
# Copy / move files from one directory to another

dirIn="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/full10kList/fullCorpus/unwanted/"
tempf="tempfile"
file="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/relevantPatIds.csv"
dirOut="/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/full10kList/fullCorpus/relevant/"

#cut -d "," -f 3 $file | cut -d " " -f 2 > $tempf

while IFS=: read -r line
do
	patname=$line.txt
        echo $dirIn$patname
	mv $dirIn$patname $dirOut
done <"$file"

#rm $tempf
