# =========================
# 0. LIBRARIES
# =========================
library(dplyr)
library(clusterProfiler)

# =========================
# 1. PATHS (EDIT ONCE HERE)
# =========================

deseq_path <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"

eggnog_path <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"

outdir <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

kog_dir <- file.path(outdir, "kog_enrichment")
go_dir  <- file.path(outdir, "go_enrichment")

dir.create(kog_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(go_dir, recursive = TRUE, showWarnings = FALSE)

# =========================
# 2. LOAD DATA
# =========================

res <- read.csv(deseq_path, row.names = 1)

eggnog <- read.delim(
  eggnog_path,
  header = FALSE,
  comment.char = "#",
  fill = TRUE,
  quote = "",
  stringsAsFactors = FALSE
)

# =========================
# 3. CLEAN GENE IDS
# =========================

clean_id <- function(x) sub("\\..*", "", x)

res_ids <- clean_id(rownames(res))
res$gene <- res_ids

eggnog$gene <- clean_id(eggnog$V1)

# =========================
# 4. DEFINE UP / DOWN GENES
# =========================

sig <- res[!is.na(res$padj) & res$padj < 0.05, ]

up <- intersect(clean_id(rownames(sig[sig$log2FoldChange > 0, ])), eggnog$gene)
down <- intersect(clean_id(rownames(sig[sig$log2FoldChange < 0, ])), eggnog$gene)

cat("UP genes:", length(up), "\n")
cat("DOWN genes:", length(down), "\n")

# =========================
# 5. =========================
#    KOG MAPPING
# =========================

kog_col <- 7   # eggnog KOG column (adjust if needed)

gene2kog <- data.frame(
  gene = eggnog$gene,
  kog  = eggnog[[kog_col]]
)

gene2kog <- gene2kog[gene2kog$kog != "-" & gene2kog$kog != "" & !is.na(gene2kog$kog), ]

term2gene_kog <- data.frame(
  term = gene2kog$kog,
  gene = gene2kog$gene
)

run_enrich <- function(gene_list, term2gene) {
  enricher(gene = gene_list, TERM2GENE = term2gene)
}

ego_kog_up <- run_enrich(up, term2gene_kog)
ego_kog_down <- run_enrich(down, term2gene_kog)

# =========================
# 6. SAVE KOG OUTPUT
# =========================

write.csv(as.data.frame(ego_kog_up),
          file.path(kog_dir, "kog_up.csv"))

write.csv(as.data.frame(ego_kog_down),
          file.path(kog_dir, "kog_down.csv"))

# safe plotting
pdf(file.path(kog_dir, "kog_up_barplot.pdf"))
if (!is.null(ego_kog_up) && nrow(as.data.frame(ego_kog_up)) > 0) {
  barplot(ego_kog_up, showCategory = 10)
}
dev.off()

pdf(file.path(kog_dir, "kog_down_barplot.pdf"))
if (!is.null(ego_kog_down) && nrow(as.data.frame(ego_kog_down)) > 0) {
  barplot(ego_kog_down, showCategory = 10)
}
dev.off()

# =========================
# 7. =========================
#    GO MAPPING (SAFE PARSE)
# =========================

go_col <- 10  # from your debug

go_raw <- eggnog[[go_col]]

keep <- go_raw != "-" & !is.na(go_raw)

gene_go <- eggnog$gene[keep]
go_raw  <- go_raw[keep]

gene_list <- rep(gene_go, lengths(strsplit(go_raw, ",")))
go_list   <- unlist(strsplit(go_raw, ","))

term2gene_go <- data.frame(
  term = go_list,
  gene = gene_list
)

# =========================
# 8. GO ENRICHMENT
# =========================

ego_go_up <- run_enrich(up, term2gene_go)
ego_go_down <- run_enrich(down, term2gene_go)

# =========================
# 9. SAVE GO OUTPUT
# =========================

write.csv(as.data.frame(ego_go_up),
          file.path(go_dir, "go_up.csv"))

write.csv(as.data.frame(ego_go_down),
          file.path(go_dir, "go_down.csv"))

# safe plots
pdf(file.path(go_dir, "go_up_barplot.pdf"))
if (!is.null(ego_go_up) && nrow(as.data.frame(ego_go_up)) > 0) {
  barplot(ego_go_up, showCategory = 10)
}
dev.off()

pdf(file.path(go_dir, "go_down_barplot.pdf"))
if (!is.null(ego_go_down) && nrow(as.data.frame(ego_go_down)) > 0) {
  barplot(ego_go_down, showCategory = 10)
}
dev.off()

# =========================
# 10. SUMMARY
# =========================

cat("\n===== DONE =====\n")
cat("UP genes:", length(up), "\n")
cat("DOWN genes:", length(down), "\n")
cat("KOG UP terms:", nrow(as.data.frame(ego_kog_up)), "\n")
cat("GO UP terms:", nrow(as.data.frame(ego_go_up)), "\n")
cat("Results saved in:", outdir, "\n")
