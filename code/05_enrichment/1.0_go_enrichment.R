library(dplyr)
library(tidyr)

deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"
eggnog_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

# DEG
deg <- read.csv(deg_file, row.names = 1)
deg$gene_id <- rownames(deg)

deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

# EGGNOG
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

# FIX: strip transcript suffix (.t1, .t2)
anno$query_gene <- sub("\\.t[0-9]+$", "", anno$query)

# MERGE
merged <- merge(deg_filt, anno, by.x = "gene_id", by.y = "query_gene")

cat("Merged rows:", nrow(merged), "\n")

# GO
go_data <- merged %>%
  filter(!is.na(GOs), GOs != "-") %>%
  select(gene_id, GOs) %>%
  separate_rows(GOs, sep = ",")

term2gene <- unique(go_data[, c("GOs", "gene_id")])

ego <- clusterProfiler::enricher(
  gene = unique(deg_filt$gene_id),
  TERM2GENE = term2gene
)

write.csv(as.data.frame(ego),
          "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/go_enrichment_results.csv",
          row.names = FALSE)

cat("GO DONE\n")
