# =========================
# 0. LIBRARIES
# =========================

library(dplyr)
library(clusterProfiler)

# =========================
# 1. LOAD DESEQ2 RESULTS
# =========================

res <- read.csv(
  "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv",
  row.names = 1
)


# clean
res <- na.omit(res)

# =========================
# 2. DEFINE SIGNIFICANT GENES
# =========================

sig <- res[!is.na(res$padj) & res$padj < 0.05, ]

up_genes <- rownames(sig[sig$log2FoldChange > 0, ])
down_genes <- rownames(sig[sig$log2FoldChange < 0, ])

# =========================
# 3. LOAD EGGNOG ANNOTATION
# =========================

eggnog <- read.delim(
  "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations",
  header = FALSE,
  comment.char = "#",
  fill = TRUE,
  quote = "",
  stringsAsFactors = FALSE
)

# =========================
# 4. BUILD GENE → KOG TABLE
# =========================

gene2kog <- data.frame(
  gene = eggnog$V1,
  kog  = eggnog$V7
)

gene2kog <- gene2kog[gene2kog$kog != "-", ]

term2gene <- data.frame(
  term = gene2kog$kog,
  gene = gene2kog$gene
)

# =========================
# 5. ENRICHMENT FUNCTION
# =========================

run_enrich <- function(gene_list, term2gene) {
  enricher(
    gene = gene_list,
    TERM2GENE = term2gene
  )
}

# =========================
# 6. RUN ENRICHMENT
# =========================
up_genes <- trimws(up_genes)
down_genes <- trimws(down_genes)

gene2kog$gene <- trimws(gene2kog$gene)

up_genes <- gsub("\\s+", "", up_genes)
down_genes <- gsub("\\s+", "", down_genes)
gene2kog$gene <- gsub("\\s+", "", gene2kog$gene)

length(intersect(up_genes, gene2kog$gene))

ego_up <- enricher(
  gene = up_genes,
  TERM2GENE = term2gene
)

ego_down <- enricher(
  gene = down_genes,
  TERM2GENE = term2gene
)

# =========================
# 7. OUTPUT DIRECTORY
# =========================

outdir <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kog_enrichment"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

# =========================
# 8. SAVE TABLES
# =========================

write.csv(as.data.frame(ego_up),
          file = file.path(outdir, "kog_up.csv"))

write.csv(as.data.frame(ego_down),
          file = file.path(outdir, "kog_down.csv"))

# =========================
# 9. PLOTS
# =========================

pdf(file.path(outdir, "kog_up_barplot.pdf"))
barplot(ego_up, showCategory = 10, title = "Upregulated genes (KOG)")
dev.off()

pdf(file.path(outdir, "kog_down_barplot.pdf"))
barplot(ego_down, showCategory = 10, title = "Downregulated genes (KOG)")
dev.off()

# =========================
# 10. SUMMARY OUTPUT
# =========================

cat("\n===== ENRICHMENT DONE =====\n")
cat("Upregulated genes:", length(up_genes), "\n")
cat("Downregulated genes:", length(down_genes), "\n")
cat("Results saved in:", outdir, "\n")
