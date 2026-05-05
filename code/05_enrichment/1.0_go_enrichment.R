library(dplyr)
library(clusterProfiler)

# =========================
# 1. PATHS 
# =========================

res_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv"
eggnog_file <- "/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations"
outdir <- "/home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment"

dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

# =========================
# 2. LOAD DATA
# =========================

res <- read.csv(res_file, row.names = 1)
eggnog <- read.delim(eggnog_file,
                     header = FALSE,
                     comment.char = "#",
                     fill = TRUE,
                     quote = "",
                     stringsAsFactors = FALSE)

# =========================
# 3. CLEAN IDS (CRITICAL FIX)
# =========================

clean <- function(x) sub("\\..*", "", x)

rownames(res) <- clean(rownames(res))
eggnog$gene <- clean(eggnog$V1)

# =========================
# 4. DIFFERENTIAL GENES
# =========================

res <- na.omit(res)

up_genes <- rownames(res[res$padj < 0.05 & res$log2FoldChange > 0, ])
down_genes <- rownames(res[res$padj < 0.05 & res$log2FoldChange < 0, ])

cat("UP genes:", length(up_genes), "\n")
cat("DOWN genes:", length(down_genes), "\n")

# =========================
# 5. PICK GO COLUMN (IMPORTANT FIX)
# =========================

go_hits <- sapply(eggnog, function(x) sum(grepl("GO:", x)))
go_col <- which(go_hits == max(go_hits))

cat("GO column:", go_col, "\n")

gene2go <- data.frame(
  gene = eggnog$gene,
  go   = eggnog[[go_col]]
)

gene2go <- gene2go[gene2go$go != "-" & gene2go$go != "" & !is.na(gene2go$go), ]

# =========================
# 6. EXPAND GO TERMS 
# =========================

gene2go$go <- as.character(gene2go$go)

split_list <- strsplit(gene2go$go, ",")

term2gene <- data.frame(
  term = rep(gene2go$go, lengths(split_list)),
  gene = rep(gene2go$gene, lengths(split_list))
)

# =========================
# 7. REMOVE BAD TERMS
# =========================

term2gene <- term2gene[grepl("GO:", term2gene$term), ]

# =========================
# 8. QUICK CHECKS
# =========================

cat("GO terms:", length(unique(term2gene$term)), "\n")
cat("GO genes:", length(unique(term2gene$gene)), "\n")

cat("UP overlap:", length(intersect(up_genes, term2gene$gene)), "\n")
cat("DOWN overlap:", length(intersect(down_genes, term2gene$gene)), "\n")

# =========================
# 9. ENRICHMENT
# =========================
# FILTER GO TERMS
term_counts <- table(term2gene$term)

valid_terms <- names(term_counts[term_counts >= 10 & term_counts <= 500])

term2gene <- term2gene[term2gene$term %in% valid_terms, ]

ego_up <- enricher(up_genes, TERM2GENE = term2gene)
ego_down <- enricher(down_genes, TERM2GENE = term2gene)

kog2gene <- data.frame(
  term = eggnog$V7,
  gene = eggnog$gene
)
kog2gene <- kog2gene[kog2gene$term != "-" & kog2gene$term != "", ]

ekog_up <- enricher(up_genes, TERM2GENE = kog2gene)
ekog_down <- enricher(down_genes, TERM2GENE = kog2gene)

# =========================
# 10. OUTPUT
# =========================

write.csv(as.data.frame(ego_up), file.path(outdir, "up_go.csv"))
write.csv(as.data.frame(ego_down), file.path(outdir, "down_go.csv"))

write.csv(as.data.frame(ekog_up), file.path(outdir, "up_kog.csv"))
write.csv(as.data.frame(ekog_down), file.path(outdir, "down_kog.csv"))

# =========================
# 11. SANITY SUMMARY
# =========================

cat("\n===== DONE =====\n")
cat("UP genes:", length(up_genes), "\n")
cat("DOWN genes:", length(down_genes), "\n")

cat("GO UP terms:", ifelse(is.null(ego_up), 0, nrow(as.data.frame(ego_up))), "\n")
cat("GO DOWN terms:", ifelse(is.null(ego_down), 0, nrow(as.data.frame(ego_down))), "\n")

cat("KOG UP terms:", ifelse(is.null(ekog_up), 0, nrow(as.data.frame(ekog_up))), "\n")
cat("KOG DOWN terms:", ifelse(is.null(ekog_down), 0, nrow(as.data.frame(ekog_down))), "\n")

cat("Results saved in:", outdir, "\n")
