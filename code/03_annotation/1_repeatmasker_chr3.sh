#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -t 02:00:00
#SBATCH --mem=32G
#SBATCH -J repeatmasker_chr3
#SBATCH -o logs/slurm-%j_repeatmasker.out

# Load module
module load RepeatMasker

# Input (polished assembly)
ASSEMBLY=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/pilon_chr3/pilon_chr3.fasta

# Output directory
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/repeatmasker_chr3
mkdir -p $OUTDIR

cd $OUTDIR

# Run RepeatMasker
RepeatMasker \
  -pa 4 \
  -species "plants" \
  -xsmall \
  -dir $OUTDIR \
  $ASSEMBLY
