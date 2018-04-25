#!/bin/bash

#this file filters out the lines that are not in ssu-headers2.txt for use in 
#the matrix making for the community analysis
#must run AFTER reduce.matrix.sh for appropriate files

for file in $(ls Archae/)
do
	while read line
	do
		#passed_filter="NO"
		name=$(echo $line | awk -F " " '{print $1 " " $2}')
		
		#echo $name
		ssu=$(cat ssu-cdhits_diatom_headers.txt | grep "$name")
		
		#echo $ssu

		if [ "$ssu" == "" ]
		then
			continue;
		else
			echo $line #line
		fi
		

	done<Archae/$file
done > "ArchaeaSSU/archaea.reduced.txt"


for file in $(ls Archaeless/)
do
  	while read line
        do
          	#passed_filter="NO"
                name=$(echo $line | awk -F " " '{print $1 " " $2}')

                ssu=$(cat ssu-cdhits_diatom_headers.txt | grep "$name")

                #echo $ssu

                if [ "$ssu" == "" ]
                then
                    	continue;
                else
			continue;
                    	#echo $line #line
                fi


        done<Archaeless/$file
done > "ArchaealessSSU/archaealess.reduced.txt"
