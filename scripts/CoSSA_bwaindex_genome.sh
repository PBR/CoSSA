#!/bin/bash

#############################################################
# the readmapper bwa uses an index to align reads to a genome
# this index has to be created just once 
#############################################################


############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\n$0 full-path/genome.fa\n" 1>&2
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


##########################
# run index
##########################
ref=$1
bwa index ${ref}
