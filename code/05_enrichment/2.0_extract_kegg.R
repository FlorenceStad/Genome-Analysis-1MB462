library(dplyr)

deg <- read.csv("analysis/05_deseq2/deseq2_results.csv")
anno <- read.delim("analysis/03_annotation/eggnog.tsv")

deg_filt <- subset(deg, padj < 0.05 & abs(log2FoldChange) > 1)

merged <- merge(deg_filt, anno, by.x="gene_id", by.y="query")

kegg <- merged %>%
  select(gene_id, KEGG_ko) %>%
  na.omit()

write.table(kegg$KEGG_ko,
            file="analysis/06_go/kegg_ko_list.txt",
            quote=FALSE,
            row.names=FALSE,
            col.names=FALSE)

cat("KEGG list DONE\n")
