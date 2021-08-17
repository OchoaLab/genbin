# genbin

`genbin` (GENetics BINaries) provides well-tested wrappers for narrow functions of several binary packages, including plink1 and plink2 (limited capabilities), gcta, bolt, gemma, and emmax.  Focuses on approaches for genetic association, population structure (kinship/GRM matrices and PCA), and heritability estimation.  Outputs are omitted unless there are errors (for easier debugging).  Parsers for the various output tables are also provided.  Complements the `genio` package (which focuses on parsing and not on binary wrappers).

## Installation

<!-- 
You can install the released version of genbin from [CRAN](https://CRAN.R-project.org) with:
``` r
install.packages("genbin")
```
-->

The current development version can be installed from the GitHub repository using `devtools`:
```R
install.packages("devtools") # if needed
library(devtools)
install_github('OchoaLab/genbin', build_opts = c())
```


## Examples

Here are two minimal pipelines we can run through R!
Several more pipelines are supported but not shown here.
The package so far assumes a Linux system, the only case that has been tested; other operating systems may or may not work.

``` r
library(genbin)
library(genio)

# examples below assume these "plink" files exist:
# name.bed, name.bim, name.fam, name.phen
name <- 'name'
# number of PCs for some examples:
n_pcs <- 10
```

### GCTA pipeline

The GCTA examples assume that `gcta64` is a binary in the system's PATH.

```r
# create GRM from plink files
gcta_grm( name )
# optional: read kinship matrix into R
data <- genio::read_grm( name )
kinship <- data$kinship

# perform mixed linear model association, returning table
data <- gcta_mlma( name )
# association p-values
data$p

# optional: calculate PCs (creates eigenvec/eigenval files)
gcta_pca( name, n_pcs = n_pcs )
# read PCs into R
data <- genio::read_eigenvec( name )
# delete eigenvec/eigenval files
delete_files_pca( name )

# cleanup
# delete GRM files
genio::delete_files_grm( name )
# delete association table
delete_files_gcta_mlma( name )
# delete log
delete_files_log( name )
```

### PLINK PCA pipeline

The plink examples assume that `plink2` is a binary in the system's PATH.

```r
# calculate PCs (creates eigenvec/eigenval files)
plink_pca( name, n_pcs = n_pcs )
# optional: read PCs into R
data <- genio::read_eigenvec( name )

# perform PCA association, returning table
data <- plink_glm( name, file_covar = paste0( name, '.eigenvec' ) )
# association p-values
data$p

# cleanup
# delete eigenvec/eigenval files
delete_files_pca( name )
# delete association table
delete_files_plink_glm( name )
# delete log
delete_files_log( name )
```
