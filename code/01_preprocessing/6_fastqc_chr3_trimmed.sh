#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc_chr3_trimmed
#SBATCH -o logs/slurm-%j.out

module load FastQC

fastqc -t 2 \
analysis/01_preprocessing/trimmed_chr3/*paired.fq.gz \
-o analysis/01_preprocessing/fastqc_trimmed_chr3/
