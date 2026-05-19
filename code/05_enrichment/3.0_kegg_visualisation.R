library(dplyr)
library(tidyr)
library(clusterProfiler)


# INPUT
deg_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"
anno_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

# OUTDIR
outdir  <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment"

# LOAD DEGs
deg <- read.csv(deg_file, row.names = 1, stringsAsFactors = FALSE)
deg$gene_id <- rownames(deg)

deg_filt <- deg %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.05 & abs(log2FoldChange) > 1)

cat("DEGs:", nrow(deg_filt), "\n")

# LOAD eggNOG (robust)
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

# fix gene IDs (remove transcript suffix)
anno$gene_id <- sub("\\.t[0-9]+$", "", anno$query)

# KEEP KEGG ONLY
anno_kegg <- anno %>%
  select(gene_id, KEGG_ko) %>%
  filter(!is.na(KEGG_ko), KEGG_ko != "-") %>%
  separate_rows(KEGG_ko, sep = ",")

cat("KEGG annotated genes:", nrow(anno_kegg), "\n")

# -----
cat("DEG example:\n")
print(head(deg$gene_id))

cat("ANNO example:\n")
print(head(anno$gene_id))

cat("Overlap:\n")
print(length(intersect(deg$gene_id, anno$gene_id)))
# -----

# MERGE
merged <- inner_join(deg_filt, anno_kegg, by = "gene_id")

cat("Mapped DEGs with KEGG:", nrow(merged), "\n")

# KEGG enrichment input
gene2ko <- merged %>%
  select(KEGG_ko, gene_id) %>%
  distinct()

# BACKGROUND = all genes with KEGG annotation
bg <- anno_kegg$gene_id

# KEGG enrichment (IMPORTANT PART)
kegg_enrich <- enricher(
  gene = unique(gene2ko$KEGG_ko),
  TERM2GENE = gene2ko,
  universe = unique(bg)
)

# RESULTS
cat("Enriched pathways:", nrow(as.data.frame(kegg_enrich)), "\n")

write.csv(as.data.frame(kegg_enrich),
          "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kegg_enrichment_results.csv",
          row.names = FALSE)

# PLOT (FIGURE FOR REPORT)
if (nrow(as.data.frame(kegg_enrich)) > 0) {
  png("/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kegg_dotplot.png",
      width = 1000, height = 700)

  print(dotplot(kegg_enrich, showCategory = 15))

  dev.off()
}

cat("KEGG enrichment DONE\n")

cat("Generating KEGG counts plot...\n")

kegg_counts <- gene2ko %>%
  count(KEGG_ko, sort = TRUE) %>%
  head(15)

print(kegg_counts)

png(file.path(outdir, "kegg_top_counts.png"),
    width = 1000, height = 700, type = "cairo")

barplot(
  kegg_counts$n,
  names.arg = kegg_counts$KEGG_ko,
  las = 2,
  col = "steelblue",
  main = "Top KEGG Orthologs in DEGs",
  ylab = "Gene count"
)

dev.off()

cat("KEGG counts plot saved\n")
