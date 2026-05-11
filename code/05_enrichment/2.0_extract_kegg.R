library(dplyr)

# PATHS 
deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"

anno_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

out_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kegg_ko_list.txt"

# READ DATA 
deg <- read.csv(deg_file, stringsAsFactors = FALSE)

anno <- read.delim(
  anno_file,
  header = TRUE,
  sep = "\t",
  fill = TRUE,
  comment.char = "#",
  quote = "",
  stringsAsFactors = FALSE
)

# QUICK SANITY CHECK
cat("DEG rows:", nrow(deg), "\n")
cat("Annotation rows:", nrow(anno), "\n")

# FILTER DEGs
deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

cat("Filtered DEGs:", nrow(deg_filt), "\n")

# FIX COLUMN MATCHING SAFELY
gene_col <- "query"

if (!"KEGG_ko" %in% colnames(anno)) {
  if ("KEGG_KO" %in% colnames(anno)) {
    anno$KEGG_ko <- anno$KEGG_KO
  } else if ("KEGG_orthologs" %in% colnames(anno)) {
    anno$KEGG_ko <- anno$KEGG_orthologs
  } else {
    stop("No KEGG column found in annotation file!")
  }
}

# MERGE
merged <- merge(
  deg_filt,
  anno,
  by.x = "gene_id",
  by.y = gene_col
)

cat("Merged rows:", nrow(merged), "\n")

# CLEAN KEGG ENTRIES
merged <- merged %>%
  filter(!is.na(KEGG_ko)) %>%
  filter(KEGG_ko != "")

kegg <- merged %>%
  select(gene_id, KEGG_ko)

# OUTPUT
dir.create(dirname(out_file), showWarnings = FALSE, recursive = TRUE)

write.table(
  kegg$KEGG_ko,
  file = out_file,
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)

cat("KEGG list DONE ->", out_file, "\n")
