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

res <- na.omit(res)

# =========================
# 2. CLEAN GENE IDS (IMPORTANT FIX)
# =========================
clean_id <- function(x) sub("\\..*", "", x)

rownames(res) <- clean_id(rownames(res))

# =========================
# 3. DEFINE SIGNIFICANT GENES
# =========================

sig <- res[!is.na(res$padj) & res$padj < 0.05, ]

up_genes   <- clean_id(rownames(sig[sig$log2FoldChange > 0, ]))
down_genes <- clean_id(rownames(sig[sig$log2FoldChange < 0, ]))

cat("UP genes:", length(up_genes), "\n")
cat("DOWN genes:", length(down_genes), "\n")

# =========================
# 4. LOAD EGGNOG
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
# 5. BUILD MAPPINGS
# =========================

gene2kog <- data.frame(
  gene = clean_id(eggnog$V1),
  kog  = eggnog$V7,
  stringsAsFactors = FALSE
)

gene2kog <- gene2kog[gene2kog$kog != "-" & gene2kog$kog != "", ]

term2gene <- data.frame(
  term = gene2kog$kog,
  gene = gene2kog$gene
)

# =========================
# 6. CHECK OVERLAP (CRITICAL DEBUG STEP)
# =========================

cat("UP overlap:", length(intersect(up_genes, gene2kog$gene)), "\n")
cat("DOWN overlap:", length(intersect(down_genes, gene2kog$gene)), "\n")

# =========================
# 7. ENRICHMENT
# =========================

ego_up <- enricher(up_genes, TERM2GENE = term2gene)
ego_down <- enricher(down_genes, TERM2GENE = term2gene)

# =========================
# 8. OUTPUT DIR
# =========================

outdir <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kog_enrichment"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

# =========================
# 9. SAVE RESULTS (SAFE CHECK)
# =========================

if (!is.null(ego_up) && nrow(as.data.frame(ego_up)) > 0) {
  write.csv(as.data.frame(ego_up),
            file.path(outdir, "kog_up.csv"))

  pdf(file.path(outdir, "kog_up_barplot.pdf"))
  barplot(ego_up, showCategory = 10, title = "Upregulated genes (KOG)")
  dev.off()
} else {
  cat("No enrichment found for UP genes\n")
}

if (!is.null(ego_down) && nrow(as.data.frame(ego_down)) > 0) {
  write.csv(as.data.frame(ego_down),
            file.path(outdir, "kog_down.csv"))

  pdf(file.path(outdir, "kog_down_barplot.pdf"))
  barplot(ego_down, showCategory = 10, title = "Downregulated genes (KOG)")
  dev.off()
} else {
  cat("No enrichment found for DOWN genes\n")
}

# =========================
# 10. DONE
# =========================

cat("\n===== ENRICHMENT COMPLETE =====\n")
