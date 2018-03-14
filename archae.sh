#!/bin/bash

for files in $(ls DadaOutputGG/) #edit for appropriate directory
do
	
	cat "DadaOutputGG/$files" | grep "Archae" > "Archae/archae.$files"
	cat "DadaOutputGG/$files" | grep -v "Archae" > "OutputArchaeless/archae.$files" #easy just grep -v to filter out other things in the future as needed

done
