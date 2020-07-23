#!/bin/bash

############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\n$0 path_to/kmer-library\n" 1>&2
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
# subtraction of kmers
##########################################
# in case the sample name with the kmc extension is given
sample=$(echo "$1" | sed 's/\.kmc_...//')

### run kmc_tools substract kmers of sample1 with kmers of sample2 to obtain sample1 specific kmers
kmc_tools transform ${sample} dump ${sample}.dump
