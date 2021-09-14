if(!exists('haversine')) source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/haversine.R')
if(!exists('mantelMultiple')) source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/mantelMultiple.R')

doDists <- TRUE
doMantel <- TRUE

if(doDists) {
  dTaxa <-
    intersect(tr$tip.label, row.names(otu.dat)[which(!is.na(otu.dat$lon))])
  dTree <- cophenetic.phylo(drop.tip(tr, which(!tr$tip.label %in% dTaxa))) %>%
    as.dist
  dEndo <- vegdist(otu[dTaxa, ], 'jaccard')
  dGeog <- haversine(otu.dat[dTaxa, ], c('lat', 'lon'))
  dDat <- otu.dat[dTaxa, ]
}

if(doMantel) {
  macI <- grep('macrocarpa', dDat$Species)
  albI <- grep('alba', dDat$Species)
  dMantels <- list(
    all = mantelMultiple(Y = dEndo, X = list(geo = dGeog, phy = dTree)),
    macro = mantelMultiple(Y = as.dist(as.matrix(dEndo)[macI, macI]),
      X = list(geo = as.dist(as.matrix(dGeog)[macI, macI]),
               phy = as.dist(as.matrix(dTree)[macI, macI]))
             ),
    alba = mantelMultiple(Y = as.dist(as.matrix(dEndo)[albI, albI]),
      X = list(geo = as.dist(as.matrix(dGeog)[albI, albI]),
               phy = as.dist(as.matrix(dTree)[albI, albI]))
             )
  )
}
print(dMantels)
