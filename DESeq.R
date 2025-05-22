# Install BiocManager and DESeq2 ----
if (!require("BiocManager")) install.packages("BiocManager")
BiocManager::install("DESeq2")
BiocManager::install("EnhancedVolcano")
library(EnhancedVolcano)
library(DESeq2)

# Read in HTSeq Data ----
directory <- "~/Desktop/Genome_Analysis_Project/Counts/09_Counts"
sampleFiles <- list.files(directory, pattern = "\\.txt$", full.names = FALSE)
sampleTable <- data.frame(sampleName = sub("\\_count.txt$","", sampleFiles), 
                          fileName = sampleFiles, 
                          condition = sub("[0-9].*", "", sampleFiles)
)
sampleTable$condition <- factor(sampleTable$condition)

# Read in Gene Products from Annotation ----
gene_names <- read.delim("~/Desktop/Genome_Analysis_Project/Counts/09_Counts/e_faecium.tsv", 
                         sep = "\t", header = TRUE)

# Do DESeq2 Analysis ----
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, 
                                       directory = directory, 
                                       design= ~ condition)
dds <- DESeq(ddsHTSeq)
res <- results(dds, name="condition_Serum_vs_BH")

# MA Plot  ----
plotMA(res, ylim = c(-5, 5), main = "MA Plot: BH vs Serum")

# Add Gene Product Names to Results and Write Out----
res_df <- as.data.frame(res)
res_df$locus_tag <- rownames(res_df)
res_annotated <- merge(res_df, gene_names, by = "locus_tag", all.x = TRUE)
res_filtered <- res_annotated[!is.na(res_annotated$log2FoldChange), ]
res_sorted <- res_filtered[order(res_filtered$log2FoldChange), ]
write.csv(res_sorted, file = "deseq2_results.csv", row.names = TRUE)

# Volcano plot with labels for the most differentially expressed genes ----
res_filtered <- res_annotated[!is.na(res_annotated$log2FoldChange), ]
res_sorted <- res_filtered[order(res_filtered$log2FoldChange), ]
gene_labels <- c(head(res_sorted$gene, 5), tail(res_sorted$gene,5))
EnhancedVolcano(
  res_sorted,
  lab = res_sorted$gene,
  title = 'BH vs Serum',
  selectLab = gene_labels,
  x = 'log2FoldChange',
  y = 'pvalue',
  pCutoff = 0.001,
  FCcutoff = 1,
  pointSize = 1,
  colAlpha = 0.5,
  legendPosition = 'right',
  drawConnectors = TRUE,
  widthConnectors = 0.5,
  max.overlaps = 20 
)

# Report Numbers of Significant Genes----
# Total Genes with (non NA) change in Expression
nrow(res_sorted)
# Number of p Significant Genes
sum(res_sorted$padj < 0.001, na.rm = TRUE)
# Number of p Significant Genes with > 2-fold change between BH and Serum
sum(res_sorted$padj < 0.001 & abs(res_sorted$log2FoldChange) > 1, na.rm = TRUE)

