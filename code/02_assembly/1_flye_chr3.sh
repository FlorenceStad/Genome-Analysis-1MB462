#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 16
#SBATCH -t 8:00:00
#SBATCH --mem=64G
#SBATCH -J flye_chr3
#SBATCH -o logs/slurm-%j.out

# Load module
module load Flye/2.9.6-GCC-13.3.0

# Define input and output paths
INPUT=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_clean_nanopore.fq.gz

OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/flye_chr3

# Create output directory 
mkdir -p $OUTDIR

# Run Flye assembly
flye \
  --nano-raw $INPUT \
  --out-dir $OUTDIR \
  --threads 2
