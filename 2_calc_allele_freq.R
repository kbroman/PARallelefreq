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

# CD-1 males and females
cd1_fem <- samples$CEL_File[samples$Sample_Name=="CD-1" & samples$Sex=="F"]
cd1_mal <- samples$CEL_File[samples$Sample_Name=="CD-1" & samples$Sex=="M"]

# allele frequencies
fem_afreq <-
    apply(g[,cd1_fem], 1, function(a) sum(table(factor(a, levels=c("A","H","B")))*c(1, 0.5, 0))/sum(!is.na(a)))
mal_afreq <-
    apply(g[,cd1_mal], 1, function(a) sum(table(factor(a, levels=c("A","H","B")))*c(1, 0.5, 0))/sum(!is.na(a)))

grayplot(fem_afreq, mal_afreq);abline(0,1)
