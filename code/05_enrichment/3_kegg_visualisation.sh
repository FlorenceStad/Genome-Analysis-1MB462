#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:10:00
#SBATCH -J kegg_enrich
#SBATCH -o logs/slurm-%j_keggvisuals.out

module load R/4.5.1-gfbf-2024a

export R_LIBS_USER=/gorilla/home/flst8788/R/x86_64-pc-linux-gnu-library/4.5

WORKDIR=/home/flst8788/Genome-Analysis-1MB462
SCRIPT=$WORKDIR/code/05_enrichment/3.0_kegg_visualisation.R

mkdir -p $WORKDIR/analysis/05_enrichment

Rscript $SCRIPT

echo "KEGG enrichment finished!"
