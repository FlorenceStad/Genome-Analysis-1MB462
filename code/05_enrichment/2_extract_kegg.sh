#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -t 01:00:00
#SBATCH -J kegg_extract
#SBATCH -o logs/slurm-%j_kegg.out

module load R/4.5.1-gfbf-2024a
export R_LIBS_USER=/gorilla/home/flst8788/R/x86_64-pc-linux-gnu-library/4.5

WORKDIR=/home/flst8788/Genome-Analysis-1MB462
SCRIPT=$WORKDIR/code/05_enrichment/2.0_extract_kegg.R

mkdir -p $WORKDIR/analysis/05_enrichment

Rscript $SCRIPT

echo "KEGG extraction finished!"
