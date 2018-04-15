#!/bin/bash

while read line
do
	if [[ "$line" = *"Cluster"* ]]
	then
		#if this is not already the reported taxonomy
		#and it's read through at least one
		if [[ $max_line != *"*"* ]] && [[ $count -gt 1 ]]
		then
			chosen1=$(echo $chosen_line | awk -F "-" '{print $1}' | awk -F ">" '{print $2}')
			chosen2=$(echo $chosen_line | awk -F "-" '{print $2}') #then print column in a way that will match with main cd-hit file
			printf "\t"			
			echo $chosen1"-"$chosen2"-"$max_name #and print what you will want it to swap with
			
		fi
		
		max_len=0
		len=0
		count=0
	else
		count=$(($count+1))
		len=$(echo $line | awk -F "-" '{print $3}' | awk -F "\." '{print $1}' | wc -c)
		
		if [[ $line != *"*"* ]]
		then
			chosen_line=$line
		fi

		if [[ max_len -eq 0 ]]
		then
			#this is for if it is the first one
			max_len=$len
		fi

		if [[ $len -gt $max_len ]] #&& [[ $line != $chosen_line ]]
		then
			max_len=$len
			max_name=$(echo $line | awk -F "-" '{print $3}' | awk -F "\." '{print $1}')
			max_line="$line" #store max line
		fi
	fi

done<"cdhitnamed.clstr"
