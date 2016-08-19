#!/bin/bash
#SBATCH -J s0_split.sl
#SBATCH -A uoo00053         # Project Account
#SBATCH --time=5:59:00     # Walltime
#SBATCH --mem-per-cpu=1000  # memory/cpu (in MB)
#SBATCH --cpus-per-task=8   # 12 OpenMP Threads
#SBATCH --nodes=1
#SBATCH -C sb

# Murray Cadzow
# University of Otago
# 29 Jul 2016

# Matt Bixley
# University of Otago
# Jun 2016
DIR=$1 #sample dir
file1=$2
file2=$3



echo split start $(date "+%H:%M:%S %d-%m-%Y")


# won't  work on NeSI with current installed split
#srun ~/ngsutils/bin/fastqutils split -gz $DIR/input/$file $DIR/temp/$fileBase $nFiles


zcat $DIR/input/$file1 | awk 'BEGIN{i=1} NR%10000000==1{if(i>1){close(x)} x="~/pigz-2.3.3/pigz -p 8 -c > temp/R1_"i++".fastq.gz"}{print | x}'
zcat $DIR/input/$file2 | awk 'BEGIN{i=1} NR%10000000==1{if(i>1){close(x)} x="~/pigz-2.3.3/pigz -p 8 -c > temp/R2_"i++".fastq.gz"}{print | x}'

#file1Num=$(ls $DIR/temp/R1*fastq.gz | wc -l)
#file2Num=$(ls $DIR/temp/R2*fastq.gz | wc -l)

#check same number of splits
#if [ $file1Num -eq $file2Num ]
#then
#    JOBID=$(sbatch --array=1-$file1Num ~/NeSI_GATK/s1_align.sl $DIR $sample $file1 $file2)
#    JOBID=$(echo $JOBID | awk '{print $4}')
#    sleep 2
#    sbatch -d $JOBID ~/NeSI_GATK/s1_gatherBam.sl $DIR $sample
#fi

echo split finish $(date "+%H:%M:%S %d-%m-%Y")
