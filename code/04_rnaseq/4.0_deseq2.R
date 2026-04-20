library(DESeq2)

# Load count data
counts <- read.table(
  "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/counts/counts.txt",
  header = TRUE,
  row.names = 1,
  comment.char = "#"
)

# Remove annotation columns from featureCounts
counts <- counts[ ,6:ncol(counts)]

# Clean column names (remove paths if present)
colnames(counts) <- gsub(".*/", "", colnames(counts))
colnames(counts) <- gsub(".sorted.bam", "", colnames(counts))

# Load metadata
coldata <- read.table(
  "/home/flst8788/Genome-Analysis-1MB462/data/metadata/rna_metadata.tsv",
  header = TRUE,
  row.names = 1
)

# Ensure same order
coldata <- coldata[colnames(counts), ]

# Create DESeq dataset
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = coldata,
  design = ~ condition
)

# Run DESeq2
dds <- DESeq(dds)

# Get results
res <- results(dds)

# Save results
write.csv(as.data.frame(res),
          file = "/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2/deseq2_results.csv")

# Summary
summary(res)

