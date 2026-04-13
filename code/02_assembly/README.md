# Genome assembly scripts (02_assembly)

This directory contains all scripts used for genome assembly and downstream assembly-related analysis in this project. The workflow includes long-read genome assembly, read alignment, and quality evaluation of the assembled genome.

---

## Workflow overview

The assembly pipeline is executed in the following order:

---

### 1. Long-read genome assembly (Flye)
- `1_flye_chr3.sh`
  Performs de novo genome assembly using Nanopore long reads with Flye.
  This step generates contigs representing the reconstructed genome sequence.

---

### 2. Read alignment to assembly (BWA)
- `2_bwa_chr3.sh`
  Maps trimmed Illumina paired-end reads back to the assembled genome using BWA.
  The resulting alignments are used for downstream polishing and quality assessment.

---

### 3. Assembly polishing (Pilon)
- `3_pilon_chr3.sh`
  Uses Illumina read alignments (BAM files) to correct errors in the draft assembly produced by Flye.

---

### 4. Assembly quality evaluation

#### QUAST
- `4_quast_chr3.sh`
  Evaluates genome assembly metrics such as contiguity, N50, and total assembly size.

#### BUSCO
- `5_busco_chr3.sh`
  Assesses genome completeness by searching for conserved single-copy orthologs.

---

## Software used

- Flye (long-read genome assembly)
- BWA (read alignment)
- Samtools (BAM processing)
- Pilon (assembly polishing)
- QUAST (assembly quality metrics)
- BUSCO (genome completeness)
- SLURM workload manager (job execution on UPPMAX)

---

## Output structure

All outputs from these scripts are stored in: analysis/02_assembly/
