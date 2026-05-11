library(dplyr)

# PATHS
deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"

anno_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

out_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kegg_ko_list.txt"

# READ DEG
deg <- read.csv(deg_file, stringsAsFactors = FALSE)
deg$gene_id <- rownames(deg)

deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

cat("DEG rows:", nrow(deg), "\n")
cat("Filtered DEGs:", nrow(deg_filt), "\n")

# READ ANNOTATION (ROBUST)
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

colnames(anno) <- trimws(colnames(anno))

cat("Annotation rows:", nrow(anno), "\n")

# FIND KEGG COLUMN SAFELY
kegg_col <- intersect(c("KEGG_ko", "KEGG_KO", "KEGG.ko"), colnames(anno))[1]

if (is.na(kegg_col)) {
  stop(" No KEGG column found in annotation file")
}

anno$KEGG_ko <- anno[[kegg_col]]

# DEBUG OVERLAP
cat("\n===== DEBUG =====\n")
cat("DEG example:\n")
print(head(deg_filt$gene_id))

cat("Annotation example:\n")
print(head(anno$query))

cat("Overlap:\n")
print(length(intersect(deg_filt$gene_id, anno$query)))

# MERGE
merged <- merge(deg_filt, anno, by.x = "gene_id", by.y = "query")

cat("Merged rows:", nrow(merged), "\n")

# CLEAN KEGG
merged <- merged %>%
  filter(!is.na(KEGG_ko), KEGG_ko != "-")

kegg <- merged %>%
  select(gene_id, KEGG_ko)

# OUTPUT
dir.create(dirname(out_file), recursive = TRUE, showWarnings = FALSE)

write.table(
  kegg$KEGG_ko,
  file = out_file,
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)

cat("KEGG DONE ->", out_file, "\n")
