# Load libraries
library(dplyr)
library(tidyr)
library(clusterProfiler)

# INPUT
deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"
eggnog_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

# READ FILES
deg <- read.csv(deg_file)
anno <- read.delim(eggnog_file)

# FILTER DEGs
deg_filt <- subset(deg, padj < 0.05 & abs(log2FoldChange) > 1)

# MERGE
merged <- merge(deg_filt, anno, by.x="gene_id", by.y="query")

# SPLIT GO TERMS
go_data <- merged %>%
  select(gene_id, GOs) %>%
  separate_rows(GOs, sep=",")

# REMOVE NA
go_data <- na.omit(go_data)

# RUN ENRICHMENT
ego <- enricher(go_data$GOs)

# SAVE OUTPUT
write.csv(as.data.frame(ego), "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/go_enrichment_results.csv")

cat("GO enrichment DONE\n")
