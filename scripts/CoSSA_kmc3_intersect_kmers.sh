#!/bin/bash

############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\n$0 path_to/sample1 path_to/sample2\n" 1>&2
}
# if less than required arguments supplied, display usage
if [  $# -ne 2 ]
then
   display_usage
   exit 1
fi
# check whether user had supplied -h or --help . If yes display usage
if [[ ( $# == "--help") ||  $# == "-h" ]]
then
   display_usage
   exit 0
fi

##########################################
# convert and alignment of selected k-mers
# to genome sequence
##########################################
# in case the sample name with the kmc extension is given
infile1=$(echo "$1" | sed 's/\.kmc_...//')
infile2=$(echo "$2" | sed 's/\.kmc_...//')
# extract file name
sample1="$(basename -- $infile1)"
sample2="$(basename -- $infile2)"

### create workdir for kmc_tools results
wkdir="k-mer_manipulations"
mkdir -p ${wkdir}

### run kmc_tools intersection of kmers between sample1 and sample2
kmc_tools -t 5 simple ${infile1} ${infile2} intersect ${wkdir}/${sample1}.${sample2}.intersect
