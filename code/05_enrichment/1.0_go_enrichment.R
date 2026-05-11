# Load libraries
library(dplyr)
library(tidyr)
library(clusterProfiler)

# INPUT
deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"
eggnog_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

# READ FILES
deg <- read.csv(deg_file, row.names = 1)
deg$gene_id <- rownames(deg)

lines <- readLines(eggnog_file)
header_idx <- grep("^#query", lines)
clean_lines <- lines[header_idx:length(lines)]

anno <- read.table(
  text = clean_lines,
  header = TRUE,
  sep = "\t",
  quote = "",
  comment.char = "",
  fill = TRUE,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# FILTER DEGs
deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

print(colnames(deg))
print(colnames(anno))

# MERGE
merged <- merge(deg_filt, anno, by.x="gene_id", by.y="#query")

# SPLIT GO TERMS
go_data <- merged %>%
  filter(GOs != "-", !is.na(GOs)) %>%
  select(gene_id, GOs)

go_data <- go_data %>%
  separate_rows(GOs, sep = ",")

# BUILD TERM ↔ GENE TABLE
term2gene <- unique(go_data[, c("GOs", "gene_id")])

# RUN ENRICHMENT 
ego <- enricher(
  gene = unique(deg_filt$gene_id),
  TERM2GENE = term2gene
)

# SAVE OUTPUT
write.csv(as.data.frame(ego), "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/go_enrichment_results.csv")

cat("GO enrichment DONE\n")
