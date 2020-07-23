#!/bin/bash 

############################################################################
# for each genotype listed in the genotypes.list KMC3 will count the 
# kmers from all the sequence reads present in the sample directory
# the produced histo file can be uploaded to Genomescope2 for visual 
# inspection and estimation of cut-off values
########################################################################### 

############################
# check for usage
############################
display_usage()
{
   echo -e "\nUsage:\n$0 genotype.list\n" 1>&2
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
# count kmers of each ample in genotype.list
##########################################
cd rawreads

while read line
do
	echo "sample: $line"
        sample=${line}
        cd ${sample}

        ### create workdir for kmc3 results
        wkdir="kmc"
        mkdir -p ${wkdir}
	cd ${wkdir}
        ### select the read files for k-mer counting
        ls -1 ../*R*.gz > seqfiles.list

        ### run kmc3
	mkdir -p kmc_tmp
	kmc -k31 -cs10000 -m2 @seqfiles.list ${sample} kmc_tmp > kmc.log

	### create k-mer histogram
	kmc_tools transform ${sample} histogram ${sample}.kmc3.histo -ci5
	### plot kmer profile	
	python3 ../../../scripts/CoSSA_plot_kmer_profile.py ${sample}.kmc3.histo
	cd ../../
done < $1
