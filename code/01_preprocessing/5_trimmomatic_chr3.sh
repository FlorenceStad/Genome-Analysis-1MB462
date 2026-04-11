#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 08:00:00
#SBATCH -J trim_chr3
#SBATCH -o logs/slurm-%j.out

module load Trimmomatic

#Run
trimmomatic PE -threads 2 \
data/raw_data/chr3_illumina_R1.fastq.gz \
data/raw_data/chr3_illumina_R2.fastq.gz \
analysis/01_preprocessing/trimmed_chr3/chr3_R1_paired.fq.gz \
analysis/01_preprocessing/trimmed_chr3/chr3_R1_unpaired.fq.gz \
analysis/01_preprocessing/trimmed_chr3/chr3_R2_paired.fq.gz \
analysis/01_preprocessing/trimmed_chr3/chr3_R2_unpaired.fq.gz \
SLIDINGWINDOW:4:20 MINLEN:50
