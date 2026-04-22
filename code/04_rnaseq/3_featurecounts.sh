#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH --mem=16G
#SBATCH -J featurecounts_chr3
#SBATCH -o logs/slurm-%j_featurecounts.out

# Load module
module load Subread/2.1.1-GCC-13.3.0

# INPUTS
BAM_DIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/hisat2_rna

# FT fil
GTF=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/braker_chr3_ET/braker.gtf

# OUTPUT
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/featurecounts
mkdir -p $OUTDIR

# RUN featureCounts
featureCounts \
  -T 2 \
  -p \
  -t exon \
  -g gene_id \
  -a $GTF \
  -o $OUTDIR/counts.txt \
  $BAM_DIR/*.bam

echo "featureCounts finished!"
