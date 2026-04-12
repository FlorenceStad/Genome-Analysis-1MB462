# Preprocessing (01_preprocessing)
This directory contains quality control and read trimming steps for both the whole genome (WG) dataset and the chromosome 3 (chr3) dataset.

---

## Storage note

Some output files are large and therefore stored in the project directory:

`/proj/uppmax2026-1-61/flst8788/Genome-Analysis-1MB462/`

instead of the home directory to avoid disk quota limitations.

Soft links are used where applicable to keep the workflow structure intact while ensuring that large files are stored on project storage.

---

## Directory structure

### FastQC (raw reads)
- `fastqc_raw_wg/` → QC of whole genome raw reads
- `fastqc_raw_chr3/` → QC of chr3 raw reads

### Trimmomatic (read trimming)
- `trimmed_wg/` → trimmed whole genome reads
- `trimmed_chr3/` → trimmed chromosome 3 reads


