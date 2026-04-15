#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH --mem=16G
#SBATCH -J fastqc_rna
#SBATCH -o /home/flst8788/Genome-Analysis-1MB462/logs/slurm-%j_fastqc_rna.out

module load FastQC

INDIR=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/rna
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/fastqc_rna

mkdir -p $OUTDIR

# Run FastQC on all RNA files
for file in $INDIR/*.fq.gz
do
    fastqc -t 4 -o $OUTDIR $file
done

