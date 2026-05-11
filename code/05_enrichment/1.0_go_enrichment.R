library(dplyr)

deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"
eggnog_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

# -------------------------
# DEG
# -------------------------
deg <- read.csv(deg_file, row.names = 1)
deg$gene_id <- rownames(deg)

deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

cat("\n===== DEG CHECK =====\n")
cat("DEG example IDs:\n")
print(head(deg_filt$gene_id))

# -------------------------
# EGGNOG READ (ROBUST)
# -------------------------
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

colnames(anno) <- gsub("^#", "", colnames(anno))

cat("\n===== ANNO CHECK =====\n")
cat("Annotation query example:\n")
print(head(anno$query))

# -------------------------
# CRITICAL CHECK: OVERLAP
# -------------------------
cat("\n===== MATCH CHECK =====\n")

overlap <- intersect(deg_filt$gene_id, anno$query)

cat("Overlap count:", length(overlap), "\n")
cat("Example overlaps:\n")
print(head(overlap))

# -------------------------
# STOP EARLY IF BROKEN
# -------------------------
if (length(overlap) == 0) {
  stop("❌ NO MATCH BETWEEN DEG AND ANNO IDs → ID SYSTEM MISMATCH")
}

# -------------------------
# MERGE ONLY IF OK
# -------------------------
merged <- merge(deg_filt, anno, by.x="gene_id", by.y="query")

cat("Merged rows:", nrow(merged), "\n")
