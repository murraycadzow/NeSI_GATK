#!/bin/bash
#SBATCH -J s3_MarkDup
#SBATCH -A uoo00053         # Project Account
#SBATCH --time=5:59:00     # Walltime
#SBATCH --mem-per-cpu=24000  # memory/cpu (in MB)
#SBATCH --cpus-per-task=1   # 12 OpenMP Threads
#SBATCH --nodes=1
#SBATCH -C sb

# Murray Cadzow
# University of Otago
# 20 Oct 2015

# Matt Bixley
# University of Otago
# Jun 2016
echo markdup start $(date "+%H:%M:%S %d-%m-%Y")

DIR=$1
sample=$2
export OPENBLAS_MAIN_FREE=1
source ~/NeSI_GATK/gatk_references.sh

module load picard/2.1.0

if ! srun java -Xmx19g -jar $EBROOTPICARD/picard.jar MarkDuplicates INPUT=$DIR/temp/${sample}_sorted_reads.bam OUTPUT=$DIR/temp/${sample}_dedup_reads.bam METRICS_FILE=$DIR/logs/metrics.txt TMP_DIR=$DIR ; then
	echo "markdup failed"
	touch $DIR/final/failed.txt
	exit 1
fi
JOBID=$(sbatch ~/NeSI_GATK/s4_index.sl $DIR $sample)
echo index $(echo $JOBID | awk '{print $4'}) >> $DIR/jobs.txt
rm $DIR/temp/${sample}_sorted_reads.bam 
echo markdup finish $(date "+%H:%M:%S %d-%m-%Y")

