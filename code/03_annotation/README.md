# Annotation scripts (03_annotation)

This directory contains all scripts used for genome annotation of the Niphotrichum japonicum chromosome 3 assembly.

The annotation workflow includes repeat masking, RNA-seq guided gene prediction (BRAKER), and preparation for downstream functional annotation.

---

## Workflow overview
The annotation pipeline is executed in the following order:

---

### 1. Repeat masking (RepeatMasker)
`1_repeatmasker_chr3.sh`

Performs repeat identification and masking on the polished genome assembly using RepeatMasker.

Output:
- masked genome (FASTA)
- repeat annotation files (.out, .tbl)

---

### 2. RNA-seq input preparation (symlinks only)
`rnaseq_for_braker/`

This directory does NOT contain processed data.

Instead, it contains symbolic links to RNA-seq alignments generated in:
analysis/04_rnaseq/mapping/

These BAM files are used as evidence for BRAKER gene prediction.

---

### 3. Gene prediction (BRAKER)
`2_braker_chr3.sh`

Runs BRAKER using:
- masked genome (from RepeatMasker)
- RNA-seq BAM files (via symlinks)

Output:
- gene models (GFF/GTF)
- predicted proteins and transcripts

---

## Software used

- RepeatMasker — repeat identification and masking
- BRAKER — gene prediction using RNA evidence
- SLURM — job execution on UPPMAX

---

## Output structure

All outputs are stored in:
analysis/03_annotation/
with subdirectories:
- repeatmasker_chr3/
- braker_chr3/
- rnaseq_for_braker/ (symlinks only)

---

## Important notes

- RNA-seq data is NOT processed in this directory
- Do NOT copy BAM files here (use symlinks only)
- BRAKER must use the masked genome, not raw assembly
- This directory is strictly for annotation steps

---

## Data flow
RepeatMasker → masked genome
↓
BRAKER gene prediction
↑
RNA-seq BAM (from 04_rnaseq via symlinks)
