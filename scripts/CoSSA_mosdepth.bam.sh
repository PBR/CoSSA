#!/bin/bash

############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\n$0 path_to/sample.bam\n" 1>&2
}
# if less than required arguments supplied, display usage
if [  $# -ne 1 ]
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
# kmer coverage analysis
##########################################

mosdepth $1 $1
python scripts/CoSSA_plot_kmer_cov_chr11.py $1.regions.bed.gz
cd bamfiles
python3 -m http.server 8000
