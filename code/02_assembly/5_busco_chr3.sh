#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH --mem=16G
#SBATCH -J busco_chr3
#SBATCH -o logs/slurm-%j_busco.out

module purge
module load BUSCO/5.7.0

# Input (use polished assembly!)
ASSEMBLY=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/pilon_chr3/pilon_chr3.fasta

# Output directory
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/busco_chr3
mkdir -p $OUTDIR

# Run BUSCO
busco \
  -i $ASSEMBLY \
  -l embryophyta_odb10 \
  -o busco_chr3 \
  --out_path $OUTDIR \
  -m genome \
  -c 2
