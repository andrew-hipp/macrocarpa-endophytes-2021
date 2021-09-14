library(ggtree)
tr2 <- drop.tip(tr, which(!tr$tip.label %in% dTaxa))
otu.dat <- otu.dat[tr2$tip.label, ]
#p <- ggtree(tr2)
tr2$tip.label <- paste(otu.dat$Species, otu.dat$State, tr2$tip.label, sep = "|")
pdf('tr.hybSeq.pdf', 8.5, 11)
plot(tr2, cex = 0.7)
dev.off()
