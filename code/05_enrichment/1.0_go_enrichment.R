library(dplyr)
library(tidyr)
library(clusterProfiler)


# INPUT FILES
deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"
eggnog_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

# READ DEG FILE
deg <- read.csv(deg_file, row.names = 1)
deg$gene_id <- rownames(deg)

deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

cat("DEGs:", nrow(deg_filt), "\n")

# READ EGGNOG FILE 
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

# remove '#' from column names
colnames(anno) <- gsub("^#", "", colnames(anno))

cat("Annotation rows:", nrow(anno), "\n")
print(colnames(anno))

# MERGE DEGs + ANNOTATION
merged <- merge(
  deg_filt,
  anno,
  by.x = "gene_id",
  by.y = "query"
)

cat("Merged rows:", nrow(merged), "\n")

# GO EXTRACTION
go_data <- merged %>%
  filter(!is.na(GOs), GOs != "-") %>%
  select(gene_id, GOs)

go_data <- go_data %>%
  separate_rows(GOs, sep = ",")

term2gene <- unique(go_data[, c("GOs", "gene_id")])

cat("GO pairs:", nrow(term2gene), "\n")

# SAFETY CHECK 
if (nrow(term2gene) == 0) {
  stop("❌ No GO mappings found — check GOs column!")
}

# ENRICHMENT
ego <- enricher(
  gene = unique(deg_filt$gene_id),
  TERM2GENE = term2gene
)

# OUTPUT

out_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/go_enrichment_results.csv"

write.csv(as.data.frame(ego), out_file, row.names = FALSE)

cat("GO enrichment DONE\n")
cat("Saved to:", out_file, "\n")
