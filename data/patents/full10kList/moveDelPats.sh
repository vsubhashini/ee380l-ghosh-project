#!/bin/bash

#dirIn="allPats/"
dirIn="patapps_dm/"
tempf="tempfile"
#file="deletedDatePats.csv"
#dirOut="deletedatepats/"
#file="dateuniqallPats.csv"
#dirOut="dateuniqallPats/"
file="datepatapps.csv"
dirOut="patappsdate_dm/"

cut -d "," -f 3 $file | cut -d " " -f 2 > $tempf

while IFS=: read -r line
do
	patname=$line.txt
        echo $dirIn$patname
	mv $dirIn$patname $dirOut
done <"$tempf"

rm $tempf
