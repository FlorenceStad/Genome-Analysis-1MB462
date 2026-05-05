library(dplyr)
library(clusterProfiler)

# 1. LOAD DESEQ2 RESULTS
res <- read.csv(
  "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv",
  row.names = 1
)

res <- na.omit(res)

# 2. CLEAN GENE IDS 
clean_id <- function(x) sub("\\..*", "", x)

res_ids <- clean_id(rownames(res))

# 3. DEFINE SIGNIFICANT GENES
sig <- res[!is.na(res$padj) & res$padj < 0.05, ]

up_genes <- clean_id(rownames(sig[sig$log2FoldChange > 0, ]))
down_genes <- clean_id(rownames(sig[sig$log2FoldChange < 0, ]))

# 4. LOAD EGGNOG
eggnog <- read.delim(
  "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations",
  header = FALSE,
  comment.char = "#",
  fill = TRUE,
  quote = "",
  stringsAsFactors = FALSE
)

# 5. CLEAN EGGNOG IDS
eggnog$gene <- clean_id(eggnog$V1)

# 6. BUILD GENE → KOG TABLE
gene2kog <- data.frame(
  gene = eggnog$gene,
  term = eggnog$V7
)

gene2kog <- gene2kog[gene2kog$term != "-" & gene2kog$term != "", ]

# 7. BUILD GENE → GO TABLE (IMPORTANT FOR HIGHER GRADE)
go_raw <- data.frame(
  gene = eggnog$gene,
  go = eggnog$V6
)

go_raw <- go_raw[go_raw$go != "-" & !is.na(go_raw$go), ]

# split GO terms (comma-separated)
go_terms <- data.frame(
  gene = rep(go_raw$gene, sapply(strsplit(go_raw$go, ","), length)),
  term = unlist(strsplit(go_raw$go, ","))
)

go_terms <- go_terms[grepl("^GO:", go_terms$term), ]

# 8. ENRICHMENT FUNCTION
run_enrich <- function(genes, term2gene) {
  enricher(
    gene = genes,
    TERM2GENE = term2gene
  )
}

# 9. RUN ENRICHMENT
ego_up_kog <- run_enrich(up_genes, gene2kog)
ego_down_kog <- run_enrich(down_genes, gene2kog)

ego_up_go <- run_enrich(up_genes, go_terms)
ego_down_go <- run_enrich(down_genes, go_terms)

# 10. OUTPUT
outdir <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/results"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

write.csv(as.data.frame(ego_up_kog), file.path(outdir, "up_kog.csv"))
write.csv(as.data.frame(ego_down_kog), file.path(outdir, "down_kog.csv"))

write.csv(as.data.frame(ego_up_go), file.path(outdir, "up_go.csv"))
write.csv(as.data.frame(ego_down_go), file.path(outdir, "down_go.csv"))

# 11. SAFE PLOTTING 
safe_barplot <- function(obj, title, file) {
  if (!is.null(obj) && nrow(as.data.frame(obj)) > 0) {
    pdf(file)
    barplot(obj, showCategory = 10, title = title)
    dev.off()
  } else {
    cat("Skipping plot:", title, "- no enrichment found\n")
  }
}
# KOG plots
safe_barplot(ego_up_kog,
             "Upregulated genes (KOG)",
             file.path(outdir, "up_kog.pdf"))

safe_barplot(ego_down_kog,
             "Downregulated genes (KOG)",
             file.path(outdir, "down_kog.pdf"))
# GO plots 
safe_barplot(ego_up_go,
             "Upregulated genes (GO)",
             file.path(outdir, "up_go.pdf"))

safe_barplot(ego_down_go,
             "Downregulated genes (GO)",
             file.path(outdir, "down_go.pdf"))
