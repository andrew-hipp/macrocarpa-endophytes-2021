library(vegan)
library(ape)
library(openxlsx)
library(magrittr)
library(ggplot2)

## read data
tr <- read.tree('https://raw.githubusercontent.com/andrew-hipp/macrocarpa-hybseq/master/DATA/trees/RAX.2018-10-15/RAxML_bipartitions.macrocarpa.hybseq.2018-10-15.tre')
tr <- root(tr, grep('rubra', tr$tip.label)) %>% ladderize
tr$tip.label <- gsub('MIR', 'MOR', tr$tip.label) #fixing one bad label
tr$tip.label <- gsub('MOR1', 'MOR_1', tr$tip.label) #fixing one bad label
tr$tip.label <- paste('OAK-MOR-00',
  sapply(strsplit(tr$tip.label, 'OAK_MOR_', fixed = T), '[', 2),
  sep = '')

meta.dna <- read.xlsx('../DATA/Oak_Sampling_MIRA_Specimen-DNA.xlsx', 1, rowNames = TRUE)
meta.spm <- read.xlsx('../DATA/Oak_Sampling_MIRA_Specimen-DNA.xlsx', 2)
row.names(meta.spm) <- meta.spm$Specimen.CODE
meta.merged <- cbind(meta.dna, meta.spm[meta.dna$SPECIMEN.CODE, ])
meta.merged$Species_ept <- gsub(' ', '', meta.merged$Species_ept, fixed = T)

otu <- read.csv('../DATA/otu.table.taxa.rare687_trans.edit2.csv', row.names=1)
row.names(otu) <- paste('OAK-MOR-', sapply(strsplit(row.names(otu), 'S'), '[', 1), sep = '')
