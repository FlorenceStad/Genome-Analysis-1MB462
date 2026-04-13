# Genome-Analysis-1MB462
A project exploring environmental moss research and analysis, as a part of the course Genome Analysis. This project is part of the course Genome Analysis and follows a standard genome assembly and annotation workflow.

# Project overview
This project performs a complete genome analysis pipeline including:
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
**01_preprocessing**
- FastQC (raw reads)
- Trimmomatic (read trimming)
- FastQC (post-trimming QC)

**02_assembly**
- Flye genome assembly (Nanopore reads)
- BWA mapping (Illumina reads → assembly)
- Pilon polishing
- Assembly evaluation (QUAST, BUSCO)

# Data Management 

All data, intermediate files, and results are stored within the project directory (This repository): /home/flst8788/Genome-Analysis-1MB462
This ensures a fully self-contained and reproducible workflow.

This contains:
- Analysis results and figures
- SLURM scripts for all pipeline steps
- Processed datasets
- Genome assemblies and evaluation outputs
- Research notes and documentation

# Authors
Florence Stadelmann, Uppsala University
