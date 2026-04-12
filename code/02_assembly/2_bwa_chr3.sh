#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 04:00:00
#SBATCH -J bwa_chr3
#SBATCH -o logs/slurm-%j_bwa.out

module load bwa
module load samtools

# Flye assembly output (symlink to be added)

# Trimmed reads (symlinked)
R1=analysis/01_preprocessing/trimmomatic_chr3/chr3_R1_paired.fq.gz
R2=analysis/01_preprocessing/trimmomatic_chr3/chr3_R2_paired.fq.gz

# Output goes to PROJ (
OUTDIR=/proj/uppmax2026-1-61/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/bwa_chr3
mkdir -p $OUTDIR

# Index assembly
bwa index $ASSEMBLY

# Align reads
bwa mem -t 2 $ASSEMBLY $R1 $R2 > $OUTDIR/aln.sam

# Convert + sort BAM
samtools view -@ 2 -bS $OUTDIR/aln.sam | \
samtools sort -@ 2 -o $OUTDIR/aln.sorted.bam

# Index BAM
samtools index $OUTDIR/aln.sorted.bam

# Cleanup
rm $OUTDIR/aln.sam
