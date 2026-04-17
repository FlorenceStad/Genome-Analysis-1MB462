#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 12:00:00
#SBATCH --mem=64G
#SBATCH -J braker_chr3
#SBATCH -o /home/flst8788/Genome-Analysis-1MB462/logs/slurm-%j_braker.out

# MODULES (Singularity-based BRAKER)
module load SAMtools/1.22-GCC-13.3.0

# PROJECT PATHS
GENOME=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/repeatmasker_chr3/pilon_chr3.fasta.masked
RNA_BAM_DIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/hisat2_rna
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/braker_chr3
BRAKER_SIF=/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/braker3.sif
PROTEIN_DB=/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/Ceratodon_purpureus/C_purpureus.faa

# FIX TMPDIR
export TMPDIR=$OUTDIR/tmp
mkdir -p $TMPDIR

mkdir -p $OUTDIR
cd $OUTDIR

# CHECK INPUTS
echo "Checking genome..."
ls -lh $GENOME

echo "Checking BAM files..."
ls $RNA_BAM_DIR/*.sorted.bam

# COLLECT BAM FILES
BAM_FILES=$(ls $RNA_BAM_DIR/*.sorted.bam | tr '\n' ',' | sed 's/,$//')

echo "BAM list:"
echo $BAM_FILES
 
# RUN BRAKER3
singularity exec \
-B $HOME/augustus_config:/opt/Augustus/config \
-B $HOME:/home/$USER \
-B /proj/uppmax2026-1-61:/proj/uppmax2026-1-61 \
$BRAKER_SIF braker.pl \
    --genome=$GENOME \
    --bam=$BAM_FILES \
    --prot_seq=$PROTEIN_DB \
    --species=chr3_moss_clean \
    --softmasking \
    --threads 2 \
    --workingdir=$OUTDIR \
    --skipOptimize 

echo "BRAKER finished successfully!"
