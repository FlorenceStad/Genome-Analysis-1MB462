#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH --mem=8G
#SBATCH -J deseq2_chr3
#SBATCH -o logs/slurm-%j_deseq2_qc.out

module load R/4.4.2-gfbf-2024a

export R_LIBS_USER=/gorilla/home/flst8788/R/x86_64-pc-linux-gnu-library/4.4

Rscript /home/flst8788/Genome-Analysis-1MB462/code/04_rnaseq/5.0_deseq2_qc.R
