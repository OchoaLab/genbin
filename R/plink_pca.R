# original: gas_plink_pca
# - plink_bin was required, now defaults to plink2 on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!

#' Estimate principal components with plink2
#'
#' A wrapper for running plink2's PCA.
#' In addition to the arguments listed below, the executable is run with `--silent`, `--nonfounders` (to use all individuals whether they are labeled as founders or not), and `--bad-freqs` (to apply even when sample sizes are very small).
#' 
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions.
#' @param name_out The base name of the output eigenvec/eigenval files (default same as input `name`), which gets extensions added automatically.
#' @param n_pcs The number of eigenvectors/eigenvalues (a.k.a. principal components) to calculate.
#' @param maf The minor allele frequency threshold to apply to data prior to eigendecomposition.
#' @param approx Apply approximate PCA algorithm.
#' @param plink_bin The path to the binary executable.
#' Default assumes `plink2` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#'
#' @return Nothing (the eigenvec/eigenval files are not read in; see example below for reading with a different function).
#'
#' @examples 
#' \dontrun{
#' # create PCs (on file)
#' plink_pca( name, name_out )
#'
#' # read file with genio
#' data <- genio::read_eigenvec( name_out )
#' }
#' 
#' @seealso
#' [genio::read_eigenvec()] for reading eigenvec files.
#' 
#' [delete_files_pca()] for deleting the eigenvec/eigenval outputs.
#'
#' [delete_files_log()] for deleting plink log files.
#' 
#' [system3()], used (with `ret = FALSE`) for executing plink2 and error handling.
#' 
#' @export
plink_pca <- function(
                      name,
                      name_out = name,
                      n_pcs = 10,
                      maf = 0.1,
                      approx = FALSE,
                      plink_bin = 'plink2',
                      threads = 0,
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    
    # don't do anything if n_pcs == 0
    if ( n_pcs == 0 )
        return()
    
    if ( Sys.which( plink_bin ) == '' )
        stop('Executable path `plink_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )

    # pass options to PCA as needed
    args <- c()
    if (approx)
        args <- c( args, 'approx' )
    
    # the arguments that are always used
    # wrap the PCA-specific args
    args <- c(
        '--silent',
        '--bfile',
        name,
        '--nonfounders',
        '--bad-freqs',
        '--maf',
        maf,
        '--pca',
        args,
        n_pcs,
        '--out',
        name_out,
        '--threads',
        threads
    )
    
    # actual run
    system3( plink_bin, args, verbose )
}

