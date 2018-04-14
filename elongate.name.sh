#!/bin/bash

while read line
do
	
	if [[ $line = *">"* ]]
	then
		header=${line:1}
		cat /Users/rachelungar/Documents/SeniorPt1/Lab/both.classification.txt | grep "$header" | \
		awk '{print ">" $1 "\t" $2 "\t" $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10}'
	else
		echo $line
	fi



done < combined.all.fasta
