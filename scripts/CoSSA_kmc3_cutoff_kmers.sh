#!/bin/bash

############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\n$0 sample low_cutoff_value high_cutoff_value \n" 1>&2
}
# if less than required arguments supplied, display usage
if [  $# -ne 3 ]
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
# select kmers between frequecy cut offs
##########################################
# in case the sample name with the kmc extension is given
infile=$(echo "$1" | sed 's/\.kmc_...//')
# extract file name
sample="$(basename -- $infile)"
low_cutoff=$2
high_cutoff=$3

### create workdir for kmc_tools results
wkdir="k-mer_manipulations"
mkdir -p ${wkdir}

### run kmc_tools with high and low frequency cut off kmers 
kmc_tools transform  ${infile} reduce -ci${low_cutoff} -cx${high_cutoff} ${wkdir}/${sample}.cutoffs.${low_cutoff}.${high_cutoff}
