library(ggrepel)

doMDS = F
if(doMDS) otu.mds <- metaMDS(otu, dist = 'jaccard')

otu.dat <- as.data.frame(otu.mds$points)
meta.merged <- meta.merged[row.names(otu.mds$points), ]
otu.dat$lat <- as.numeric(meta.merged$latitude.orig)
otu.dat$Latitude <- otu.dat$lat
otu.dat$lon <- as.numeric(meta.merged$longitude.orig)
otu.dat$Species <- meta.merged$Species_ept
otu.dat$State <- meta.merged$'state/province'
otu.dat$blackHills <- ifelse(meta.merged$'state/province' == 'South Dakota', 'Black Hills', NA)

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")[1:length(unique(otu.dat$Species))]
names(cbbPalette) <- unique(otu.dat$Species)

p <- ggplot(otu.dat, aes(x = MDS1,
                         y = MDS2,
                         label = blackHills))
p <- p + geom_point(aes(size = Latitude, color = Species))
p <- p + scale_colour_manual(values=cbbPalette)
p <- p + geom_label_repel()
#p <- p + theme(legend.position = c(0.1,0.8), panel.spacing = unit(0.1, 'in'))

print(p)
ggsave('otu.mds.pdf', p, width = 8, height = 6, units = 'in')
