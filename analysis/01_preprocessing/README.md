# Preprocessing (01_preprocessing)
This directory contains quality control for both whole genome and chromosome 3, as well as and read trimming steps and post-trimming quality control for the chromosome 3 (chr3) dataset.

---
## Directory structure

### FastQC (quality control)

- `fastqc_raw_wg/` → QC of whole genome raw reads
- `fastqc_raw_chr3/` → QC of chromosome 3 raw reads

### Trimmomatic (read trimming)

- `trimmed_wg/` → trimmed whole genome reads
- `trimmed_chr3/` → trimmed chromosome 3 reads

---

## Workflow steps

1. Quality control of raw reads using FastQC
2. Read trimming and filtering using Trimmomatic
3. Post-trimming quality control using FastQC

---

## Output

All outputs are stored within the project directory structure under: analysis/01_preprocessing/


