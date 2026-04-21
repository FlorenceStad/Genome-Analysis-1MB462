#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH --mem=64G
#SBATCH -J braker_chr3_ET
#SBATCH -o /home/flst8788/Genome-Analysis-1MB462/logs/slurm-%j_braker_ET.out

# Load modules
module load SAMtools/1.22-GCC-13.3.0

# Paths
GENOME=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/repeatmasker_chr3/pilon_chr3.fasta.masked
RNA_BAM_DIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/hisat2_rna
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/braker_chr3_ET
BRAKER_SIF=/proj/uppmax2026-1-61/Genome_Analysis/2_Zhou_2023/braker3.sif

# Create output + tmp
mkdir -p $OUTDIR
export TMPDIR=$OUTDIR/tmp
mkdir -p $TMPDIR

cd $OUTDIR

echo "Checking genome..."
ls -lh $GENOME

echo "Checking BAM files..."
ls $RNA_BAM_DIR/*.sorted.bam

# Collect BAM files
BAM_FILES=$(ls $RNA_BAM_DIR/*.sorted.bam | tr '\n' ',' | sed 's/,$//')

echo "BAM list:"
echo $BAM_FILES

# Run BRAKER3 (ET-mode: ONLY RNA, no proteins)
singularity exec \
-B $HOME/augustus_config:/opt/Augustus/config \
-B $HOME:/home/$USER \
-B /proj/uppmax2026-1-61:/proj/uppmax2026-1-61 \
$BRAKER_SIF braker.pl \
    --genome=$GENOME \
    --bam=$BAM_FILES \
    --species=chr3_moss_ET \
    --softmasking \
    --threads=2 \
    --workingdir=$OUTDIR

echo "BRAKER ET-mode finished!"
