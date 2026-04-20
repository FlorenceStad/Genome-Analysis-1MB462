#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH --mem=16G
#SBATCH -J featurecounts_chr3
#SBATCH -o logs/slurm-%j_featurecounts.out

# Load module
module load Subread/2.0.6

# INPUTS
BAM_DIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/hisat2_rna

# ⚠️Finns ej än
GTF=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/braker_chr3/braker.gtf

# OUTPUT
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/counts
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
