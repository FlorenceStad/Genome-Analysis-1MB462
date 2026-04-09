#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:30:00
#SBATCH -J fastqc_WG
#SBATCH -o logs/slurm-%j.out

# Load modules
module load FastQC

# Run FastQC
fastqc -t 2 /home/flst8788/Genome-Analysis-1MB462/data/raw_data/CRR809859_*.fq.gz \
-o /home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/fastqc_raw/
