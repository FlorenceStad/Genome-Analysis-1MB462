#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH --mem=8G
#SBATCH -J deseq2_chr3
#SBATCH -o logs/slurm-%j_deseq2.out

module load R/4.3.1

Rscript /home/flst8788/Genome-Analysis-1MB462/code/04_rnaseq/deseq2_chr3.R
