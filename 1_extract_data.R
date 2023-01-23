# extract data from MDA.db
# - samples.csv
# - par_markers.csv
# - par_genotypes.csv

library(RSQLite)

# connect to MDA.db sqlite database
con <- dbConnect(SQLite(), dbname="MDA.db")

# extract samples.csv
sampleList <- dbReadTable(con, "sampleList") # sample information
write.table(sampleList, "samples.csv", sep=",",
            col.names=TRUE, row.names=FALSE, quote=TRUE)

# extract par_markers
par_markers <- dbGetQuery(con, "SELECT * FROM snpInfo WHERE IsInPAR==1") # 26 x 16
write.table(par_markers, "par_markers.csv", sep=",",
            col.names=TRUE, row.names=FALSE, quote=TRUE)

# extract par_genotypes
geno_par <- lapply(par_markers[,1], function(marker)
    dbGetQuery(con, paste0("SELECT * FROM genotype WHERE snpId=='", marker, "'")))
# rbind the results
geno_par <- do.call("rbind", geno_par)

write.table(geno_par, "par_genotypes.csv", sep=",",
            col.names=TRUE, row.names=FALSE, quote=TRUE)
