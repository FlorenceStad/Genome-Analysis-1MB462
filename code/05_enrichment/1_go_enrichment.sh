#!/bin/bash -l

#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH -J go_enrichment
#SBATCH -o logs/slurm-%j_go_enrichment.out

# LOAD MODULES
module load R/4.5.1-gfbf-2024a
export R_LIBS_USER=/gorilla/home/flst8788/R/x86_64-pc-linux-gnu-library/4.5

# PATHS
WORKDIR=/home/flst8788/Genome-Analysis-1MB462
SCRIPT=$WORKDIR/code/05_enrichment/1.0_go_enrichment.R

# CREATE OUTPUT DIR
mkdir -p $WORKDIR/analysis/06_go

# RUN
Rscript $SCRIPT

echo "GO enrichment job finished!"
