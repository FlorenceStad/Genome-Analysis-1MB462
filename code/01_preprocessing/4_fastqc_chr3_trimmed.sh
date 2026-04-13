#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_chr3_trimmed
#SBATCH -o logs/slurm-%j.out

module load FastQC

# Input (UPDATED: no /proj)
INPUT=/home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/trimmed_chr3

# Output directory
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/fastqc_trimmed_chr3

mkdir -p $OUTDIR

# Run FastQC
fastqc -t 2 \
$INPUT/*.fastq.gz \
-o $OUTDIR
