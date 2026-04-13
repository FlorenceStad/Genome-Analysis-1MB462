#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH --mem=32G
#SBATCH -J pilon_chr3
#SBATCH -o logs/slurm-%j_pilon.out

module load Pilon
module load SAMtools/1.22.1-GCC-13.3.0

# -----------------------
# INPUT PATHS
# -----------------------

ASSEMBLY=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/flye_chr3/assembly.fasta

BAM=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/bwa_chr3/aln.sorted.bam

OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/pilon_chr3

mkdir -p $OUTDIR
mkdir -p logs

# -----------------------
# INDEX BAM (safety step)
# -----------------------
samtools index $BAM

# -----------------------
# RUN PILON
# -----------------------

java -Xmx30G -jar $PILON_JAR \
  --genome $ASSEMBLY \
  --frags $BAM \
  --output pilon_chr3 \
  --outdir $OUTDIR \
  --threads 2 \
  --changes \
  --vcf
