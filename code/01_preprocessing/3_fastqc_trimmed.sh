#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_trimmed
#SBATCH -o logs/slurm-%j.out

module load FastQC

# Run FastQC
fastqc -t 2 /home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/trimmed/*paired.fq.gz \
-o /home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/fastqc_trimmed/

