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
# 2. FIX SAMPLE NAMES (VIKTIGT)
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

# =========================
# 6. OUTPUT
# =========================

outdir <- "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

write.csv(as.data.frame(res),
          file = file.path(outdir, "deseq2_results.csv"))

summary(res)
