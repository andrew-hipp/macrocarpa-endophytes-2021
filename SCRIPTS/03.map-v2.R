library(ggplot2)
library(gridExtra)
library(ggmap)
library(maps)
library(mapdata)
library(ggrepel)
library(rgdal)
library(plyr)
library(proj4)
library(magrittr)


proj4string <- c("+proj=aea", #albers equal area
                 "+lon_0=-82",
                  "+ellps=clrk66",
                  "+lat_1=38",
                   "+lat_2=42",
                   "+lat_0=40",
                   "+units=m",
                   "+x_0=0",
                   "+y_0=0",
                   "+datum=WGS84",
                   "+axis=enu"
                 )
# Source data
if(!exists('mapsLittle')) {
  mapsLittle <- lapply(dir('../DATA/little-maps'), function(x) {
    temp <- readOGR(dsn=paste('../DATA/little-maps/', x, sep = ''),
                    layer=strsplit(x, '_', fixed = T)[[1]][2])
    temp@data$id = rownames(temp@data)
    temp.points = fortify(temp, region="id")
    temp.df = join(temp.points, temp@data, by="id")
    temp.df$Species <- paste('Quercus',
                        strsplit(x, '_', fixed = T)[[1]][1])
    names(temp.df)[10:11] <- c('ID1', 'ID2')
    temp.df$spGroup <- paste(strsplit(x, '_', fixed = T)[[1]][1],
                             temp.df$group, sep = '')
    temp.df
  })
  names(mapsLittle) <- sapply(strsplit(dir('../DATA/little-maps'), '_', fixed = T),
                              function(x) x[1])
  xy <- as.data.frame(mapsLittle$macrocarpa[, c('long', 'lat')])
  pj <- project(xy, proj4string, inverse=TRUE)
  mapsLittle$macrocarpa$lat <- pj$y
  mapsLittle$macrocarpa$long <- pj$x
}

states <- map_data("state")
counties <- map_data('county')
otu.dat$blackHills1 <- otu.dat$blackHills
otu.dat$blackHills1[which(!is.na(otu.dat$blackHills1))[1:3]] <- NA
p <- ggplot()
p <- p + geom_polygon(data = counties,
                      aes(x = long, y = lat, group = group),
                      fill = 'gray90', color = "white",
                      lwd = 0.1)
p <- p + geom_polygon(data = states,
                      aes(x = long, y = lat, group = group),
                      fill = NA, color = "gray70",
                      lwd=0.3)

p <- p + geom_polygon(data = mapsLittle$macrocarpa,
                      aes(x =long, y =lat, group = spGroup),
                      fill = 'gray60',
                      alpha = 0.4
                      )
p <- p + coord_fixed(1.3)
p <- p + coord_map('albers', lat0=40, lat1=38)
p <- p + scale_fill_manual(values = cbbPalette)
p <- p + scale_colour_manual(values = cbbPalette)
p <- p + scale_x_continuous('Longitude')
p <- p + scale_y_continuous('Latitude')
p <- p + theme(legend.position = c(0.1,0.25), panel.spacing = unit(0.1, 'in'))

p <- p + geom_point(data = otu.dat,
                    mapping = aes(x = lon, y = lat,
                                  colour = Species),
                    #colour = 'black',
                    size = ifelse(otu.dat$Species == 'macrocarpa', 4, 2.5)
                    )
p <- p + geom_label_repel(aes(label=blackHills1, x = lon, y = lat), data = otu.dat)
ggsave('Fig.map-withRange.pdf', plot = p,
        width = 8, height = 7.5, units = 'in')
