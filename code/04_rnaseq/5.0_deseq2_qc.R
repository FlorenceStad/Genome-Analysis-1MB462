library(DESeq2)

# =========================
# 1. LOAD COUNTS
# =========================

counts <- read.table(
  "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/featurecounts/counts.txt",
  header = TRUE,
  comment.char = "#",
  check.names = FALSE
)

countData <- counts[, -(1:6)]
rownames(countData) <- counts$Geneid


# =========================
# 2. FIX SAMPLE NAMES
# =========================

# tar bort hela pathen
colnames(countData) <- basename(colnames(countData))

# tar bort featureCounts suffix
colnames(countData) <- sub("\\.sorted\\.bam$", "", colnames(countData))

# säkerhetskoll
colnames(countData) <- trimws(colnames(countData))

# =========================
# 3. LOAD METADATA
# =========================
coldata <- read.table(
  "/home/flst8788/Genome-Analysis-1MB462/data/meta_data/rna_metadata.tsv",
  header = TRUE,
  sep = "\t",
  stringsAsFactors = FALSE
)

rownames(coldata) <- coldata$sample
coldata$sample <- NULL

rownames(coldata) <- trimws(rownames(coldata))

# =========================
# 4. ALIGN SAMPLES
# =========================

coldata <- coldata[colnames(countData), , drop = FALSE]

# HARD CHECK (stopp direkt om fel)
if (!identical(colnames(countData), rownames(coldata))) {
  cat("COUNT NAMES:\n")
  print(colnames(countData))

  cat("META NAMES:\n")
  print(rownames(coldata))

  stop("Sample names do not match after cleaning")
}

# =========================
# 5. DESEQ2 ANALYSIS
# =========================

dds <- DESeqDataSetFromMatrix(
  countData = round(countData),
  colData = coldata,
  design = ~ condition
)

# filter low counts
dds <- dds[rowSums(counts(dds)) > 10, ]

# run model
dds <- DESeq(dds)

# results
res <- results(dds)
res_df <- as.data.frame(res)

# =========================
# 6. OUTPUT
# =========================

outdir <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

write.csv(as.data.frame(res),
          file = file.path(outdir, "deseq2_qc_results.csv"))

summary(res)
cat("Results saved\n")

# =========================
# 7. PCA
# =========================

vsd <- vst(dds, blind = FALSE)

pca <- prcomp(t(assay(vsd)))

pdf("/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/pca.pdf")

plot(
  pca$x[,1],
  pca$x[,2],
  col = as.factor(coldata$condition),
  pch = 19,
  xlab = "PC1",
  ylab = "PC2"
)

legend("topright",
       legend = levels(as.factor(coldata$condition)),
       col = 1:length(levels(as.factor(coldata$condition))),
       pch = 19)

dev.off()

# =========================
# 8. MA Plot
# =========================

pdf("/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/ma_plot.pdf")
plotMA(dds, ylim = c(-5, 5))
dev.off()

# =========================
# 9. Volcano Plot (base R)
# =========================

sig <- !is.na(res_df$padj) & res_df$padj < 0.05

pdf("/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/volcano.pdf")

plot(
  res_df$log2FoldChange,
  -log10(res_df$padj),
  pch = 20,
  col = ifelse(sig, "red", "black"),
  xlab = "log2FC",
  ylab = "-log10(padj)"
)

dev.off()

cat("QC complete\n")
