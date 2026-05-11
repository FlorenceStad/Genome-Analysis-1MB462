library(dplyr)

deg <- read.csv("/home/flst8788/Genome-Analysis-1MB462/analysis/04_rnaseq/deseq2_qc/deseq2_qc_results.csv")
anno <- read.delim("/home/flst8788/Genome-Analysis-1MB462/analysis/03_annotation/eggnog_chr3/chr3_eggnog.emapper.annotations")

deg_filt <- subset(deg, padj < 0.05 & abs(log2FoldChange) > 1)

merged <- merge(deg_filt, anno, by.x="gene_id", by.y="query")

kegg <- merged %>%
  select(gene_id, KEGG_ko) %>%
  na.omit()

write.table(kegg$KEGG_ko,
            file="home/flst8788/Genome-Analysis-1MB462/analysis/05_enrichment/kegg_ko_list.txt",
            quote=FALSE,
            row.names=FALSE,
            col.names=FALSE)

cat("KEGG list DONE\n")
