library(DESeq2)

# Load count data
counts <- read.table(
  "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/counts/counts.txt",
  header = TRUE,
  comment.char = "#"
  stringAsFactors = FALSE
)

# Remove annotation columns from featureCounts
countData <- counts[, -(1:6)]
rownames(countData) <- counts$Geneid

# Clean column names (remove paths if present)
colnames(countData) <- basename(colnames(countData))
colnames(countData) <- sub("\\.sorted\\.bam$", "", colnames(countData))

# Load metadata
coldata <- read.table(
  "/home/flst8788/Genome-Analysis-1MB462/data/metadata/rna_metadata.tsv",
  header = TRUE,
  row.names = 1
  stringsAsFactors = FALSE
)

# Ensure same order
coldata <- coldata[colnames(counts), ]

if (!all(colnames(countData) == rownames(coldata))) {
  stop("ERROR: sample names in counts and metadata do not match!")
}

# Create DESeq dataset
dds <- DESeqDataSetFromMatrix(
  countData = round(countData),
  colData = coldata,
  design = ~ condition
)

# Filter low counts
dds <- dds[rowSums(counts(dds)) > 10, ]

# Run DESeq2
dds <- DESeq(dds)

# Get results
res <- results(dds)

# Save results
dir.create("/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2",
           showWarnings = FALSE, recursive = TRUE)

write.csv(as.data.frame(res),
          file = "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2/deseq2_results.csv")

summary(res)
