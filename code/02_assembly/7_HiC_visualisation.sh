#!/bin/bash
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 06:00:00
#SBATCH -J hic_cooler
#SBATCH -o logs/hic_cooler_%j.out

# -------------------
# MODULES
# -------------------
module load SAMtools/1.22.1-GCC-13.3.0
module load pairtools/1.1.2-gfbf-2024a
module load cooler/0.10.4-foss-2024a
module load BWA/0.7.19-GCCcore-13.3.0

# -------------------
# INPUTS
# -------------------

FASTA=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/yahs_hic/yahs.out_scaffolds_final.fa
R1=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_hiC_R1.fastq.gz
R2=/home/flst8788/Genome-Analysis-1MB462/data/raw_data/chr3_hiC_R2.fastq.gz

# -------------------
# OUTPUT
# -------------------
OUTDIR=/home/flst8788/Genome-Analysis-1MB462/analysis/02_assembly/HiC_visualisation

# -------------------
# TMP
# -------------------
TMPDIR=${SNIC_TMP}/hic_${SLURM_JOB_ID}
mkdir -p "$TMPDIR"
cd "$TMPDIR"
echo "TMPDIR: $TMPDIR"

# -------------------
# 1. INDEXERING (BWA & FASTA)
# -------------------
echo "Indexerar FASTA för samtools..."
samtools faidx "$FASTA"

echo "Indexerar FASTA för BWA (om det inte redan är gjort)..."
if [ ! -f "${FASTA}.bwt" ]; then
    bwa index "$FASTA"
fi

# -------------------
# 2. SUPER-PIPE: Mappning -> Pairtools -> Cooler
# -------------------
echo "Startar BWA -> Pairtools -> Cooler..."

# BWA MEM med -5SP är standard för Hi-C (förhindrar att den lagar "konstiga" par)
bwa mem -5SP -t 2 "$FASTA" "$R1" "$R2" | \
\
# Eftersom bwa spottar ut par, kan vi skippa samtools sort!
pairtools parse \
    --chroms-path "${FASTA}.fai" \
    --nproc-in 2 \
    --nproc-out 2 \
    --drop-seq | \
\
pairtools sort \
    --nproc 2 \
    --memory 4G \
    --tmpdir "$TMPDIR" | \
\
pairtools dedup | \
\
cooler cload pairs \
    -c1 2 -p1 3 -c2 4 -p2 5 \
    "${FASTA}.fai:10000" \
    - \
    hic_10kb.cool

# -------------------
# 3. BALANCE & MOVE
# ------------------- 
if [ -f hic_10kb.cool ]; then
    echo "Balancing matrix..."
    cooler balance -p 2 hic_10kb.cool
    
    mkdir -p "$OUTDIR"
    mv hic_10kb.cool "$OUTDIR/"
    echo "=== SUCCESS ==="
else
    echo "FEL: hic_10kb.cool skapades aldrig!"
fi
