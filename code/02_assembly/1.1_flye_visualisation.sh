#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -t 00:30:00
#SBATCH -J bandage_chr3
#SBATCH -o logs/slurm-%j_bandage.out

module load Bandage

# PATHS
ASSEMBLY_DIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/flye_chr3
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/flye_visualisation
mkdir -p $OUTDIR

cd $ASSEMBLY_DIR

echo "Running Bandage on Flye assembly graph..."

Bandage image assembly_graph.gfa \
$OUTDIR/bandage_chr3.png \
--width 2000 \
--height 2000 \
--depth \
--fontsize 12

echo "Done! Output saved to bandage_chr3.png"
