#!/bin/bash

##################################################################################
# fastp quality and preprocessing of sequence reads
# script assumes that the seq files are  stored per sample in seperate directories
# the script will run for all samples mentioned in the genotypes.list
##################################################################################

############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\t$0 reads_to_process\n\n\tspecify how many reads/pairs to be processed. Default 0 means process all reads.\n" 1>&2
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
# convert and alignment of selected k-mers
# to genome sequence
##########################################
while read line
do
	sample=${line}
	cd ${sample}
	
	### create workdir for fastp results
	wkdir="fastp"
	mkdir -p ${wkdir}

	### select the first read files for fastp analysis
	R1=$(ls *R1*.gz| head -1)
	R2=$(ls *R2*.gz| head -1)

	### run fastp
	fastp -w 5 -i ${R1} -I ${R2} -o ${wkdir}/${sample}.R1.trim.fq.gz -O ${wkdir}/${sample}.R2.trim.fq.gz \
	-h ${wkdir}/${sample}_fastp.html \
	-j ${wkdir}/${sample}_fastp.json \
	-R "${sample} fastp report" \
        -l 70 -y 20 -5 --cut_front_window_size 1 -3 --cut_tail_window_size 1 -r --reads_to_process 1000000
	cd ../

done < genotypes.list
