#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH --mem=32G
#SBATCH -J busco_hic
#SBATCH -o logs/slurm-%j_busco_hic.out

module load BUSCO/5.8.2-gfbf-2024a

# INPUT
ASSEMBLY=/home/flst8788/fresh_repo/analysis/02_assembly/yahs_hic/yahs.out_scaffolds_final.fa

# OUTPUT
OUTDIR=/home/flst8788/fresh_repo/analysis/02_assembly/busco_hic
mkdir -p $OUTDIR

# RUN
busco \
  -i $ASSEMBLY \
  -l embryophyta_odb10 \
  -o busco_hic \
  --out_path $OUTDIR \
  -m genome \
  -c 4
