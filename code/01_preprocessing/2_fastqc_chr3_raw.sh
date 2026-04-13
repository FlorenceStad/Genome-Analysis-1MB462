#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_chr3_raw
#SBATCH -o logs/slurm-%j.out

# Load module
module load FastQC

mkdir -p /home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/fastqc_raw_chr3

fastqc -t 2 \
/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_illumina_R1.fastq.gz \
/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_illumina_R2.fastq.gz \
-o /home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/fastqc_raw_chr3/
