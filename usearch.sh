#!/bin/bash

for files in $(ls diatomdir_isoformless/)
do
	usearch -cluster_fast $files -id 1 -centroids "diatomdir_usearch/$files" 
done
