#!/usr/bin/python
import re

d_diatoms = {}

#save "cluster" as key and rest of information in values
with open("cdhits.clstr") as f_clstr:
	for line in f_clstr:
		if ">Cluster" in line:
			key = line
		else:
			name = re.split('>',line)[1]
			d_diatoms.setdefault(key, []).append(name)

#get this txt file by seeing steps in readme
with open("ssu-cdhits_headers.txt") as f:
	for line in f:
		for k,v in d_diatoms.items():
			for the_v in v:
				the_vsplit = re.split('<',the_v)
				line=line.strip()
				#print(line, " maybe is ", the_v) #check to make sure 

				#if header from filter is in the value, then print out all headers in that key
				if line in the_v:	
					for need_v in v:
						linesplit = re.split('<',need_v)
						print(linesplit[0], linesplit[1])
					#print(k)
	
					break
		break
