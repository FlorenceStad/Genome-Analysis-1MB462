#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH --mem=8G
#SBATCH -J go_enrichment
#SBATCH -o logs/slurm-%j_go_enrichment.out

module load R/4.4.2-gfbf-2024a
module load R-bundle-Bioconductor/3.20-foss-2024a-R-4.4.2

export R_LIBS_USER=/gorilla/home/flst8788/R/x86_64-pc-linux-gnu-library/4.4

Rscript /home/flst8788/Genome-Analysis-1MB462/code/05_enrichment/1.0_go_enrichment.R

