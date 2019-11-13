#!usr/bin/bash

###########################################################################
# This script processes assembled scaffolds, adding treatment groups to   #
# fasta sequence headers, removing short contigs, removing line breaks    #
# from fasta sequences, checks for circular contigs.                      #
# Working installations of BBMap and CContigs is required to              #
# to run this script.                                                     #
###########################################################################


### This chunk checks for whether the scaffold directory exists
# and creates it if it doesn't. This directory is necessary for the
# steps in the code below.

if [ -d "data/raw/scaffolds/" ]
then
    	echo "Scaffolds read folder already exists, continuing..."
        echo
else
    	echo "Scaffolds read folder doesn't exist, creating and continuing..."
        echo
        mkdir data/raw/scaffolds
fi

### This chunk adds filenames to fasta headers, concatenates scaffolds into a 
# single file, and removes scaffolds under 1000 bases long

echo "Removing contigs under 1kb, adding treatment groups to fasta headers, and concatenating contigs into single file"
echo

for treatment in $(awk '{ print $2 }' data/process/samples.tsv); do

        reformat.sh minlength=1000 overwrite=t in=data/raw/assembly/"$treatment"/transcripts.fasta out=data/raw/scaffolds/"$treatment"_scaffolds.fasta
        sed 's/^>/>'"$treatment"'_/g' data/raw/scaffolds/"$treatment"_scaffolds.fasta >> data/raw/scaffolds/all_long_scaffolds.fasta

done


### This chunk removes line breaks from the sequences for easy extraction
# later using grep

echo "Removing line breaks from the scaffold sequences and creating whole scaffold file"
echo
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' data/raw/scaffolds/all_long_scaffolds.fasta > data/raw/scaffolds/all_scaffolds.fasta