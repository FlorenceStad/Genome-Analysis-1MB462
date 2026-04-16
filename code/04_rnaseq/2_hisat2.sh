#!/bin/bash -l

#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -t 06:00:00
#SBATCH --mem=32G
#SBATCH -J hisat2_chr3_rna
#SBATCH -o /home/flst8788/Genome-Analysis-1MB462/logs/slurm-%j_hisat2_rna.out

module load HISAT2/2.2.1-gompi-2024a
module load SAMtools/1.22-GCC-13.3.0

# Paths
REF=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/pilon_chr3/pilon_chr3.fasta
READS=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/rna
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/hisat2_rna

mkdir -p $OUTDIR

# STEP 1: Build HISAT2 index
INDEX_PREFIX=$OUTDIR/chr3_index

if [ ! -f "${INDEX_PREFIX}.1.ht2" ]; then
    hisat2-build -p 4 $REF $INDEX_PREFIX
fi

# STEP 2: Samples (paired-end)
SAMPLES=(
Control_1
Control_2
Control_3
Heat_treated_42_12h_1
Heat_treated_42_12h_2
Heat_treated_42_12h_3
)

# STEP 3: Alignmemt
for s in "${SAMPLES[@]}"
do
    echo "Processing sample: $s"

    R1=$READS/${s}_f1.fq.gz
    R2=$READS/${s}_r2.fq.gz

    OUTBAM=$OUTDIR/${s}.sorted.bam

    hisat2 \
        -p 4 \
        -x $INDEX_PREFIX \
        -1 $R1 \
        -2 $R2 \
        | samtools sort -@ 4 -o $OUTBAM

    samtools index $OUTBAM

done

