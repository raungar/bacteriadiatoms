#!/bin/bash

for files in $(ls DadaOutputGG3/)
do

        cat "DadaOutputGG3/$files" | sed "s/-/./g" | grep "Archae" > "Archae/archae.$files"
        cat "DadaOutputGG3/$files" | sed "s/-/./g" | grep -v "Archae" > "Archaeless/archaeless.$files" #easy just grep -v to filter out other things $

done
