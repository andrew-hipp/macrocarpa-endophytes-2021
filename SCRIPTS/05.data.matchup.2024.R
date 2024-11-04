# matching up data from Peter Kennedy with metadata

library(openxlsx)

dat.pk <- read.csv('DATA/2017_endophytes_OTU_with_taxonomy_ITS2_Map.csv')
dat.meta <- read.xlsx('DATA/Oak_Sampling_MIRA_Specimen-DNA.xlsx', 2)
row.names(dat.meta) <- dat.meta$Specimen.CODE
dat.pk <- cbind(dat.pk, dat.meta[dat.pk$SPECIMEN.CODE,])
fields.to.use <- which(apply(dat.pk, 2, function(x) !all(is.na(x))))
dat.pk <- dat.pk[, fields.to.use]
write.csv('OUT/2017_endophytes_wAllData_2024-11-04.csv')