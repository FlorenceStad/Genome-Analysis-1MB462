#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH -J yahs_chr3
#SBATCH -o logs/slurm-%j.out

# MODULES
module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22-GCC-13.3.0
module load YaHS/1.2.2-foss-2024a

# INPUT FILES
R1=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_hiC_R1.fastq.gz
R2=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_hiC_R2.fastq.gz

GENOME=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/pilon_chr3/pilon_chr3.fasta

# OUTPUT
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/yahs_hic
mkdir -p $OUTDIR
cd $OUTDIR

# INDEX
bwa index $GENOME

# MAP Hi-C
bwa mem -5SP -t 8 $GENOME $R1 $R2 | samtools view -Sb - > hic.bam

samtools sort -@ 8 -o hic.sorted.bam hic.bam
samtools index hic.sorted.bam

# YAHS scaffolding
yahs $GENOME hic.sorted.bam

echo "YAHS scaffolding done"
