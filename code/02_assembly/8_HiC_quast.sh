#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J quast_hic
#SBATCH -o logs/slurm-%j_quast_hic.out

module load QUAST/5.3.0-gfbf-2024a

# INPUT
PILON=/home/flst8788/fresh_repo/analysis/02_assembly/pilon_chr3/pilon_chr3.fasta
HIC=/home/flst8788/fresh_repo/analysis/02_assembly/yahs_hic/yahs.out_scaffolds_final.fa

# OUTPUT
OUTDIR=/home/flst8788/fresh_repo/analysis/02_assembly/quast_hic
mkdir -p $OUTDIR

# RUN
quast.py \
  $PILON \
  $HIC \
  -o $OUTDIR \
  -t 2
