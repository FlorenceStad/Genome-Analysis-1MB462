#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 04:00:00
#SBATCH --mem=16G
#SBATCH -J busco_braker_ET
#SBATCH -o /home/flst8788/Genome-Analysis-1MB462/logs/slurm-%j_busco_braker_ET.out

# Load modules 
module load BUSCO/5.8.2-gfbf-2024a

# Paths
INPUT=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/braker_chr3_ET/braker.aa
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/busco_braker_ET
SIF=/proj/uppmax2026-1-61/Genome_Analysis/busco.sif

# Lineage dataset (plants)
LINEAGE=embryophyta_odb10

mkdir -p $OUTDIR
cd $OUTDIR

echo "Running BUSCO on BRAKER ET proteins..."

busco \
  -i $INPUT \
  -l $LINEAGE \
  -o busco_braker_ET \
  -m proteins \
  --cpu 2

echo "BUSCO finished!"
