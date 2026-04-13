#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 08:00:00
#SBATCH -J trim_chr3
#SBATCH -o logs/slurm-%j.out

module load Trimmomatic

# Input files
R1=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_illumina_R1.fastq.gz
R2=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_illumina_R2.fastq.gz

# Output directory
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/trimmed_chr3

mkdir -p $OUTDIR

# Run Trimmomatic
trimmomatic PE -threads 2 \
$R1 \
$R2 \
$OUTDIR/chr3_R1_paired.fq.gz \
$OUTDIR/chr3_R1_unpaired.fq.gz \
$OUTDIR/chr3_R2_paired.fq.gz \
$OUTDIR/chr3_R2_unpaired.fq.gz \
SLIDINGWINDOW:4:20 MINLEN:50
