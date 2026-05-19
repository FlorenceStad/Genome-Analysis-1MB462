library(dplyr) 

# PATHS 
deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"

anno_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

out_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kegg_ko_list.txt"

# DEG (FIXED)
deg <- read.csv(deg_file, row.names = 1, stringsAsFactors = FALSE)
deg$gene_id <- rownames(deg)

deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

# ANNO
lines <- readLines(anno_file)
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

colnames(anno) <- gsub("^#", "", colnames(anno))

# FIX ID
anno$query_gene <- sub("\\.t[0-9]+$", "", anno$query)

# MERGE (FIXED)
merged <- merge(deg_filt, anno, by.x = "gene_id", by.y = "query_gene")

cat("Merged rows:", nrow(merged), "\n")

# KEGG CLEAN
library(tidyr)

kegg <- merged %>%
  select(gene_id, KEGG_ko) %>%
  filter(!is.na(KEGG_ko), KEGG_ko != "-") %>%
  separate_rows(KEGG_ko, sep = ",")

# OUTPUT
write.table(
  kegg$KEGG_ko,
  file = out_file,
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)

cat("KEGG DONE\n")
