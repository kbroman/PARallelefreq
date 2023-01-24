# load sample info
samples <- read.csv("samples_annotated.csv")
# Use_for_analysis   = 1 if I thought we should use it
# CEL_File           = should be the name in the genotype data, but some -/_ differences
# Outbred
# Classical
# Wild_derived
# NotMusMusculus
# wild_mice
# Sample_Name
# Sex (M or F)

# load PAR genotypes
g <- read.csv("par_genotypes.csv")
g[g=="N"] <- NA

# fix the -/_ problems by making them all _
colnames(g) <- sapply(strsplit(colnames(g), "[-_]"), paste, collapse="_")
samples$CEL_File <- sapply(strsplit(samples$CEL_File, "[-_]"), paste, collapse="_")

# verify that the sample IDs are now all the same
stopifnot( all(samples$CEL_File == colnames(g)[-1]) )

# outbred samples are all CD-1 or NMRI, but the NMRI mice are *all* males
table(samples$Sample_Name[samples$Outbred==1])
table(samples$Sex[samples$Sample_Name=="NMRI"])

## wild-derived and classical inbreds: basically all males
table(samples$Sex[samples$Classical==1 & samples$Use_for_analysis ==1])    # just 4/111 female
table(samples$Sex[samples$Wild_derived==1 & samples$Use_for_analysis ==1]) # just 2/75 female

## so all we have is the CD-1 population

# CD-1 males and females
cd1_fem <- samples$CEL_File[samples$Sample_Name=="CD-1" & samples$Sex=="F"]
cd1_mal <- samples$CEL_File[samples$Sample_Name=="CD-1" & samples$Sex=="M"]

# get genotype counts
fem_g <- apply(g[,cd1_fem], 1, function(a) table(factor(a, levels=c("A","H","B"))))
mal_g <- apply(g[,cd1_mal], 1, function(a) table(factor(a, levels=c("A","H","B"))))
cd1_gtable <- t(rbind(fem_g, mal_g))
colnames(cd1_gtable) <- paste0(rep(c("fem", "mal"), each=3), colnames(cd1_gtable))
rownames(cd1_gtable) <- g[,1]

# calc pvalues
p <- apply(cd1_gtable, 1, function(a) {
    atab <- rbind(c(2*a[1]+a[2],a[2]+2*a[3]),
                  c(2*a[4]+a[5],a[5]+2*a[6]))
    if(atab[1,2]==0 && atab[2,2]==0) return(1)
    chisq.test(atab)$p.value })

# calc allele freq
afreq <- apply(cd1_gtable, 1, function(a) {
    atab <- rbind(c(2*a[1]+a[2],a[2]+2*a[3]),
          c(2*a[4]+a[5],a[5]+2*a[6]))
    result <- atab[,2]/rowSums(atab)
    names(result) <- paste0(c("fem_", "mal_"), "afreq")
    result })

cd1_gtable <- cbind(cd1_gtable, t(afreq), pvalue=p)
cd1_gtable <- cbind(marker=rownames(cd1_gtable), cd1_gtable)
write.table(cd1_gtable, "CD1_allele_freq.csv", sep=",",
            quote=FALSE, col.names=TRUE, row.names=FALSE)
