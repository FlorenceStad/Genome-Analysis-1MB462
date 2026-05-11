#!/bin/bash -l

#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH -J go_enrichment
#SBATCH -o logs/slurm-%j_go_enrichment.out

# LOAD MODULES
module load R/4.3.1

# PATHS
WORKDIR=/home/flst8788/Genome-Analysis-1MB462
SCRIPT=$WORKDIR/scripts/go_enrichment.R

# CREATE OUTPUT DIR
mkdir -p $WORKDIR/analysis/06_go

# RUN
Rscript $SCRIPT

echo "GO enrichment job finished!"
