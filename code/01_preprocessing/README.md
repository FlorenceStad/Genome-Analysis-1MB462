# Preprocessing scripts (01_preprocessing)

This directory contains all scripts used for preprocessing sequencing data in this project. The workflow includes quality control (FastQC) and read trimming (Trimmomatic) for both whole genome (WG) and chromosome 3 (chr3) datasets.

---

## Workflow overview

The preprocessing pipeline is executed in the following order:

### 1. Raw quality control (WG)
- `1_fastqc_WG_raw.sh`
  Performs FastQC on raw whole genome reads to assess initial quality.

### 2. Trimming (WG)
- `2_trimmomatic_WG.sh`
  Trims adapters and low-quality bases from whole genome reads using Trimmomatic.

### 3. Post-trimming quality control (WG)
- `3_fastqc_trimmed.sh`
  Runs FastQC on trimmed whole genome reads to verify improvement in quality.

---

### 4. Raw quality control (chr3)
- `4_fastqc_chr3_raw.sh`
  Performs FastQC on raw chromosome 3 reads.

### 5. Trimming (chr3)
- `5_trimmomatic_chr3.sh`
  Trims chromosome 3 reads using Trimmomatic with the same parameters as WG.

### 6. Post-trimming quality control (chr3)
- `6_fastqc_chr3_trimmed.sh`
  Runs FastQC on trimmed chromosome 3 reads.

---

## Software used

- FastQC (quality control)
- Trimmomatic (read trimming)
- SLURM workload manager (job execution on UPPMAX)

---

## Output structure

All outputs from these scripts are stored in: analysis/01_preprocessing/ with subdirectories.
