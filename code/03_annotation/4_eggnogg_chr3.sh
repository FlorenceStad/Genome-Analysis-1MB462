#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 18:00:00
#SBATCH --mem=32G
#SBATCH -J eggnog_chr3
#SBATCH -o /home/flst8788/Genome-Analysis-1MB462/logs/eggnog_%j.out

#Load modules
module load eggnog-mapper/2.1.13-gfbf-2024a

# paths
BRAKER_DIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/braker_chr3_ET
PROTEINS=$BRAKER_DIR/braker.aa

OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3
mkdir -p $OUTDIR
cd $OUTDIR


#Run eggNOG-mapper
emapper.py \
    -i $PROTEINS \
    -o chr3_eggnog \
    -m hmmer \
    -d viridiplantae \
    --output_dir $OUTDIR \
    --itype proteins \
    --cpu 2 \
    --sensmode ultra-sensitive \
    --override \
    --go_evidence all \
    --pfam_realign realign \
    --usemem 
