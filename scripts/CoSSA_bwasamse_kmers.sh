#!/bin/bash

############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\n$0 full-path/genome.fa sample\n" 1>&2
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

ref=$1
infile=$2
sample="$(basename -- $2)"

### convert kmers to fasta format
kmc_tools -hp transform ${infile} dump ${infile}.dump
awk '{ print ">" FNR "\n" $1}' ${infile}.dump | \
gzip > ${infile}.fa.gz

### align kmers, remove duplicate kmers and store in dir bamfiles
mkdir -p bamfiles
bwa aln -n 3 ${ref} ${infile}.fa.gz > ${infile}.sai
bwa samse ${ref} ${infile}.sai ${infile}.fa.gz | \
sambamba view -S -f bam /dev/stdin | \
sambamba sort --tmpdir ${infile}.tmp /dev/stdin -o ${infile}.srt.bam
sambamba markdup -r --tmpdir ${infile}.tmp ${infile}.srt.bam bamfiles/${sample}.bam
