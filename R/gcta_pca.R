# original: gas_lmm_gcta_pca
# - gcta_bin was required, now defaults to gcta64 on path
# - removed `debug` option
# - added `name_out` option, default used to be `paste0( name, '-n_pcs_', n_pcs )`
# - returned list(runtime), new doesn't!

#' Estimate principal components with GCTA
#'
#' A wrapper for running GCTA's PCA.
#' 
#' @param name The shared name of the input binary GRM files without extensions.
#' @param name_out The base name of the output eigenvec/eigenval files (default same as input `name`), which gets extensions added automatically.
#' @param n_pcs The number of eigenvectors/eigenvalues (a.k.a. principal components) to calculate.
#' @param gcta_bin The path to the binary executable.
#' Default assumes `gcta64` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#'
#' @return Nothing (the eigenvec/eigenval files are not read in; see example below for reading with a different function).
#'
#' @examples 
#' \dontrun{
#' # create PCs (on file)
#' gcta_pca( name, name_out )
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
#' [delete_files_log()] for deleting GCTA log files.
#' 
#' [system3()], used (with `ret = FALSE`) for executing GCTA and error handling.
#'
#' <http://cnsgenomics.com/software/gcta/#PCA>
#' 
#' @export
gcta_pca <- function(
                     name,
                     name_out = name,
                     n_pcs = 10,
                     gcta_bin = 'gcta64',
                     threads = 0,
                     verbose = TRUE
                     ) {
    if ( missing( name ) )
        stop('Binary GRM file path (name, without extension) is required!')
    
    # don't do anything if n_pcs == 0
    if ( n_pcs == 0 )
        return()
    
    if ( Sys.which( gcta_bin ) == '' )
        stop('Executable path `gcta_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    
    # check that GRM files are present
    genio::require_files_grm(name)

    args <- c(
        '--grm',
        name,
        '--pca',
        n_pcs,
        '--out',
        name_out,
        '--thread-num',
        threads
    )
    
    # actual run
    system3( gcta_bin, args, verbose )
}

