# RNA-seq analysis scripts (04_rnaseq)

This directory contains all scripts used for RNA-seq analysis in Niphotrichum japonicum under heat stress conditions.

The workflow includes quality control, read trimming, alignment to the genome, expression quantification, and differential expression analysis.

---

## Workflow overview

The RNA-seq pipeline is executed in the following order:

---

### 1. Quality control (FastQC)
`01_fastqc.sh`

Performs quality control of raw RNA-seq reads to assess sequencing quality.

Output:
- HTML quality reports
- per-base quality metrics

---

### 2. Read trimming (Trimmomatic) *(optional depending on QC)*
`02_trimmomatic.sh`

Removes adapters and low-quality bases from RNA-seq reads.

Output:
- trimmed FASTQ files

---

### 3. Post-trimming QC (FastQC)
`03_fastqc_trimmed.sh`

Validates quality improvement after trimming.

---

### 4. RNA-seq alignment (HISAT2)
`04_hisat2.sh` 

Aligns RNA-seq reads to the masked genome assembly.

Output:
- BAM files (sorted and indexed)

These BAM files are also used as input for:
- BRAKER gene prediction (03_annotation)

---

### 5. Read counting
`05_featurecounts.sh`

Counts reads mapped to each gene using annotation from BRAKER.

Output:
- gene count matrix

---

### 6. Differential expression analysis (DESeq2)
`06_deseq2.R`

Identifies differentially expressed genes between:
- control vs heat stress conditions

Output:
- DEG tables
- normalized expression matrices

---

## Software used

- FastQC — quality control
- Trimmomatic — read trimming
- HISAT2 / STAR — RNA alignment
- SAMtools — BAM processing
- featureCounts — gene quantification
- DESeq2 (R) — differential expression analysis
- SLURM — job execution on UPPMAX

---

## Output structure

All outputs are stored in:
analysis/04_rnaseq/
with subdirectories:
- fastqc/
- trimmed/
- mapping/
- counts/
- deseq2/

---

## Data flow
RNA FASTQ
↓
FastQC → Trimming → FastQC
↓
HISAT2 / STAR alignment
↓
BAM files
↓
featureCounts → DESeq2
↓
Differential expression results


---

## Important notes

- RNA-seq data is processed ONLY in this directory
- BAM files are reused in 03_annotation via symlinks
- Ensure consistent genome version between mapping and annotation
- Keep raw FASTQ files unchanged
