#!/bin/bash

#SBATCH --time=24:0:0
#SBATCH --mem=30G
#SBATCH -n 8
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=$EMAIL

CONFIG=$1

module load Java

freec -conf ${CONFIG} -sample $SAMPLE_MPILEUP_FILE -control /$CONTROL_MPILEUP_FILE

cd CNV_exome/

cat /hpc/local/CentOS7/hub_clevers/software/FREEC-11.6/scripts/assess_significance.R | R --slave --args *_CNVs  *_ratio.txt

cat /hpc/local/CentOS7/hub_clevers/software/FREEC-11.6/scripts/makeGraph.R | R --slave --args 2 *_ratio.txt *_BAF.txt 

cat /hpc/local/CentOS7/hub_clevers/software/FREEC-11.6/scripts/makeKaryotype.R | R --slave --args 2 4 5000000 *_ratio.txt
