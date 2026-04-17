#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -t 12:00:00
#SBATCH --mem=32G
#SBATCH -J eggnog_chr3
#SBATCH -o eggnog_%j.out

module load Singularity/4.1.0

# paths
BRAKER_DIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/braker_chr3
PROTEINS=$BRAKER_DIR/braker.aa   # dubeelkolla

OUTDIR=$BRAKER_DIR/functional_annotation
mkdir -p $OUTDIR

# eggNOG container # dubbelkolla
EGGNOG_SIF=/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/eggnog-mapper.sif

singularity exec \
-B $BRAKER_DIR:$BRAKER_DIR \
$EGGNOG_SIF emapper.py \
    -i $PROTEINS \
    -o chr3_eggnog \
    --output_dir $OUTDIR \
    --itype proteins \
    --cpu 4 \
    --itype proteins \
    --sensmode ultra \
    --data_dir $OUTDIR/eggnog_db \
    --override \
    --go_evidence all \
    --pfam_realign hmm \
    --target_orthologs all \
    --tax_scope auto
