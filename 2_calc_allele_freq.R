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

# fix the -/_ problems by making them all _
colnames(g) <- sapply(strsplit(colnames(g), "[-_]"), paste, collapse="_")
samples$CEL_File <- sapply(strsplit(samples$CEL_File, "[-_]"), paste, collapse="_")

# verify that the sample IDs are now all the same
stopifnot( all(samples$CEL_File == colnames(g)[-1]) )
