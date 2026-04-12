# Genome-Analysis-1MB462
A project exploring environmental moss research and analysis, as a part of the course Genome Analysis. This project is part of the course Genome Analysis and follows a standard genome assembly and annotation workflow.

# About the Project
In this project we:
- Quality control of sequencing reads (FastQC)
- Read trimming and preprocessing (Trimmomatic)
- Genome assembly using long reads (Flye)
- Assembly polishing using short reads (Pilon)
- Assembly quality evaluation (QUAST, BUSCO)
- Downstream analysis and annotation (planned)

The main biological focus is chromosome 3, while whole-genome data is used for comparison where needed.

# Repository Contents
- Project documentation
- Research notes and reports
- Data collected during the project
- Code and analysis tools

# Repository Structure

The project is organized into:
- analysis/ → workflow outputs and results
- code/ → all analysis scripts (SLURM jobs)
- data/ → raw and linked input data
- logs/ → SLURM output logs

# Key workflow steps
01_preprocessing → FastQC + Trimmomatic
02_assembly → Flye → BWA → Pilon → QUAST → BUSCO

## Workflow Summary
1. FastQC (raw reads)
2. Trimmomatic (read trimming)
3. FastQC (post-trimming QC)
4. Flye genome assembly (Nanopore reads)
5. BWA mapping (Illumina → assembly)
6. Pilon polishing
7. Assembly evaluation (QUAST, BUSCO)
8. ...

# Data Management 

Due to UPPMAX storage limitations, this project uses a **mirrored directory structure**.

## Home directory (this repository)
Located at: /home/flst8788/Genome-Analysis-1MB462

This contains:
- Code (scripts)
- Project structure
- Symlinks to large datasets
- Files intended for GitHub submission

## Project directory (UPPMAX storage)
Located at: /proj/uppmax2026-1-61/flst8788/Genome-Analysis-1MB462

This contains:
- Large output files (e.g. Flye assembly, BAM files)
- Computationally heavy results
- Intermediate pipeline data

## Symlink strategy

To keep workflow reproducible and GitHub-friendly:
- Large outputs are stored in `/proj`
- Accessed via symbolic links in `/home`
- This ensures:
  - no home quota issues
  - clean GitHub structure
  - reproducible analysis pipeline

Example: analysis/01_preprocessing/trimmomatic_chr3 → /proj/.../trimmed_chr3

# Authors
Florence Stadelmann, Uppsala University
