#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 08:00:00
#SBATCH -J trim_WG
#SBATCH -o logs/slurm-%j.out

# Load modules
module load Trimmomatic

# Run Trimmomatic (paired-end)
trimmomatic PE -threads 4 \
data/raw_data/CRR809859_f1.fq.gz \
data/raw_data/CRR809859_r2.fq.gz \
analysis/01_preprocessing/trimmed/CRR809859_f1_paired.fq.gz \
analysis/01_preprocessing/trimmed/CRR809859_f1_unpaired.fq.gz \
analysis/01_preprocessing/trimmed/CRR809859_r2_paired.fq.gz \
analysis/01_preprocessing/trimmed/CRR809859_r2_unpaired.fq.gz \
SLIDINGWINDOW:4:20 MINLEN:50
