#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_chr3_raw
#SBATCH -o logs/slurm-%j.out

module load FastQC

fastqc -t 2 \
data/raw_data/chr3_illumina_R1.fastq.gz \
data/raw_data/chr3_illumina_R2.fastq.gz \
-o analysis/01_preprocessing/fastqc_raw_chr3/
