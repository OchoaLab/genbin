#' genbin: R wrappers for binaries in genetics
#'
#' Conveniently run genetics analysis involving external binary executables from R.
#' Pipelines support simple procedures for creating, reading, and cleaning up files, in some cases complemented by the `genio` package.
#'
#' @examples
#' \dontrun{
#' library(genbin)
#' library(genio)
#'
#' # examples below assume these "plink" files exist:
#' # name.bed, name.bim, name.fam, name.phen
#' name <- 'name'
#' # number of PCs for some examples:
#' n_pcs <- 10
#' 
#' ### GCTA pipeline
#'
#' # The GCTA examples assume that `gcta64` is a binary in the system's PATH.
#'
#' # create GRM from plink files
#' gcta_grm( name )
#' # optional: read kinship matrix into R
#' data <- genio::read_grm( name )
#' kinship <- data$kinship
#'
#' # perform mixed linear model association, returning table
#' data <- gcta_mlma( name )
#' # association p-values
#' data$p
#'
#' # optional: calculate PCs (creates eigenvec/eigenval files)
#' gcta_pca( name, n_pcs = n_pcs )
#' # read PCs into R
#' data <- genio::read_eigenvec( name )
#' # delete eigenvec/eigenval files
#' delete_files_pca( name )
#' 
#' # cleanup
#' # delete GRM files
#' genio::delete_files_grm( name )
#' # delete association table
#' delete_files_gcta_mlma( name )
#' # delete log
#' delete_files_log( name )
#'
#' ### PLINK PCA pipeline
#'
#' # The plink examples assume that `plink2` is a binary in the system's PATH.
#' 
#' # calculate PCs (creates eigenvec/eigenval files)
#' plink_pca( name, n_pcs = n_pcs )
#' # optional: read PCs into R
#' data <- genio::read_eigenvec( name )
#'
#' # perform PCA association, returning table
#' data <- plink_glm( name, file_covar = paste0( name, '.eigenvec' ) )
#' # association p-values
#' data$p
#'
#' # cleanup
#' # delete eigenvec/eigenval files
#' delete_files_pca( name )
#' # delete association table
#' delete_files_plink_glm( name )
#' # delete log
#' delete_files_log( name )
#' 
#' }
#' 
#' @docType package
#' @name genbin-package
#' @aliases genbin
#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
