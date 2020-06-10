#$ -q stat.q
#$ -S /bin/bash
#$ -M danny.esselink@wur.nl
#$ -m be
#$ -pe sharedmem 5

cd /media/scratchpad_01/essel002/CoSSA

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
   echo -e "\nUsage:\n$0\n" 1>&2
}
# if less than required arguments supplied, display usage
if [  $# -ne 0 ]
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

### activate conda environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate CoSSA

##########################################
# convert and alignment of selected k-mers
# to genome sequence
##########################################

while read line
do
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
	kmc -k31 -m2 @seqfiles.list ${sample} kmc_tmp -t 5 > kmc.log

	### create k-mer histogram
	kmc_tools -t 5 transform ${sample} histogram ${sample}.kmc3.histo
	cd ../../

done < genotypes.list

### deactivate environment
conda deactivate
