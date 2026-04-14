#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH -J bwa_chr3
#SBATCH -o logs/slurm-%j_bwa.out

module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0

# Flye assembly output
ASSEMBLY=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/flye_chr3/assembly.fasta

# Trimmed paired reads
R1=/home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/trimmed_chr3/chr3_R1_paired.fq.gz
R2=/home/flst8788/Genome-Analysis-1MB462/analysis/01_preprocessing/trimmed_chr3/chr3_R2_paired.fq.gz

# Output
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/bwa_chr3

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
