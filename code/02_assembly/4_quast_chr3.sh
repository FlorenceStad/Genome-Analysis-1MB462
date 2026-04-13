#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:30:00
#SBATCH -J quast_chr3
#SBATCH -o logs/slurm-%j_quast.out

module load QUAST/5.2.0

# Input assemblies
FLYE=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/flye_chr3/assembly.fasta
PILON=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/pilon_chr3/pilon_chr3.fasta

# Output directory
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/quast_chr3
mkdir -p $OUTDIR

# Run QUAST
quast.py \
  $FLYE \
  $PILON \
  -o $OUTDIR \
  -t 2
