# make dummy phen, R code

library(genio)

name <- 'dummy-33-101-0.1'

# need this info for starters and to match up with data
fam <- read_fam( name )

# dummy pheno
fam$pheno <- rnorm( nrow( fam ) )

# write it now!
write_phen( name, fam )
