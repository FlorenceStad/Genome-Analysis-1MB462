library(clusterProfiler)
library(dplyr)

# =========================
# 1. PATHS
# =========================

base_out <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/GO_enrichment"

res_path <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"

eggnog_path <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog.tsv"

dir.create(base_out, recursive = TRUE, showWarnings = FALSE)

# =========================
# 2. LOAD DESEQ2 RESULTS
# =========================

res <- read.csv(res_path, row.names = 1)

sig <- res[!is.na(res$padj) & res$padj < 0.05, ]
genes <- rownames(sig)

up_genes <- rownames(sig[sig$log2FoldChange > 0, ])
down_genes <- rownames(sig[sig$log2FoldChange < 0, ])

# =========================
# 3. LOAD EGGNOG ANNOTATION
# =========================

eggnog <- read.table(
  eggnog_path,
  header = TRUE,
  sep = "\t",
  quote = "",
  comment.char = ""
)

# adjust column names if needed
eggnog <- eggnog[, c("Gene", "GOs")]

eggnog <- eggnog[eggnog$GOs != "-", ]

# =========================
# 4. BUILD GENE → GO MAP
# =========================

gene2go <- data.frame(
  gene = rep(eggnog$Gene, lengths(strsplit(eggnog$GOs, ","))),
  go   = unlist(strsplit(eggnog$GOs, ","))
)

gene2go <- na.omit(gene2go)

# =========================
# 5. ENRICHMENT
# =========================

ego_all <- enricher(genes, TERM2GENE = gene2go)
ego_up <- enricher(up_genes, TERM2GENE = gene2go)
ego_down <- enricher(down_genes, TERM2GENE = gene2go)

# =========================
# 6. SAVE RESULTS
# =========================

write.csv(as.data.frame(ego_all),
          file.path(base_out, "go_all.csv"))

write.csv(as.data.frame(ego_up),
          file.path(base_out, "go_up.csv"))

write.csv(as.data.frame(ego_down),
          file.path(base_out, "go_down.csv"))

# =========================
# 7. PLOTS
# =========================

pdf(file.path(base_out, "go_all_barplot.pdf"))
barplot(ego_all, showCategory = 15)
dev.off()

pdf(file.path(base_out, "go_up_barplot.pdf"))
barplot(ego_up, showCategory = 15)
dev.off()

pdf(file.path(base_out, "go_down_barplot.pdf"))
barplot(ego_down, showCategory = 15)
dev.off()

cat("GO enrichment complete\n")
