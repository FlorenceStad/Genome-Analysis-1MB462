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
DB=/sw/data/eggNOG/5.0.0/rackham/

OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3
mkdir -p $OUTDIR
cd $OUTDIR

#Run eggNOG-mapper
emapper.py \
    -i $PROTEINS \
    -o chr3_eggnog \
    --output_dir $OUTDIR \
    --itype proteins \
    --cpu 2 \
    -m diamond \
    --data_dir /sw/data/eggNOG/5.0.0/rackham \
    --sensmode ultra-sensitive \
    --override \
    --go_evidence all \
    --pfam_realign realign 
