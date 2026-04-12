#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 08:00:00
#SBATCH -J trim_WG
#SBATCH -o logs/slurm-%j.out

# Load modules
module load Trimmomatic

# Input files (direct from project storage)
R1=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/CRR809859_f1.fq.gz
R2=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/CRR809859_r2.fq.gz

# Output directory in proj
OUTDIR=/proj/uppmax2026-1-61/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/trimmed_wg

mkdir -p $OUTDIR

# Run Trimmomatic
trimmomatic PE -threads 2 \
$R1 \
$R2 \
$OUTDIR/CRR809859_f1_paired.fq.gz \
$OUTDIR/CRR809859_f1_unpaired.fq.gz \
$OUTDIR/CRR809859_r2_paired.fq.gz \
$OUTDIR/CRR809859_r2_unpaired.fq.gz \
SLIDINGWINDOW:4:20 MINLEN:50
