# orig: herit_lmm_gcta
# - gcta_bin was required, now defaults to gcta64 on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!

#' Run GCTA REML and return the estimated heritability.
#'
#' A wrapper for running GCTA variance component estimation followed by reading of the results by [read_gcta_hsq()].
#'
#' @param name The shared default name of the input and output files without extensions.
#' @param name_grm The shared name of the input binary GRM files without extensions (default same as input `name`).
#' @param name_phen The base name of the phenotype file without PHEN extension (default same as input `name`).
#' @param name_out The base name of the output variance component file (default same as input `name`), which gets extension ".hsq" added automatically.
#' @param gcta_bin The path to the binary executable.
#' Default assumes `gcta64` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed, followed by the the path of the output file being read (after autocompleting the extensions).
#'
#' @return A list containing the estimated heritability, its standard error, and the full table of estimated variance components, as a `tibble`, read with [read_gcta_hsq()] (see that for more info).
#'
#' @examples 
#' \dontrun{
#' obj <- gcta_reml( name, name_out )
#' obj$herit
#' }
#' 
#' @seealso
#' [gcta_grm()] for estimating the kinship (GRM) matrix with GCTA.
#' 
#' [read_gcta_hsq()] for parsing the output of GCTA MLMA.
#'
#' [delete_files_gcta_hsq()] and [delete_files_log()] for deleting the GCTA output files.
#'
#' [system3()], used (with `ret = FALSE`) for executing GCTA and error handling.
#' 
#' @export
gcta_reml <- function(
                      name,
                      name_grm = name,
                      name_phen = name,
                      name_out = name,
                      gcta_bin = 'gcta64',
                      threads = 0,
                      verbose = TRUE
                      ) {
    if (missing(name))
        stop('Input file path (name, without extension; default for GRM, PHEN, and output files) is required!')
    
    if ( Sys.which( gcta_bin ) == '' )
        stop('Executable path `gcta_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    
    # check that GRM and phen files are present
    genio::require_files_phen( name_phen )
    genio::require_files_grm( name_grm )

    # the arguments that are always used
    args <- c(
        '--reml',
        '--grm',
        name_grm,
        '--pheno',
        paste0( name_phen, '.phen' ),
        '--out',
        name_out,
        '--thread-num',
        threads
    )

    # actual run
    system3( gcta_bin, args, verbose )

    # parse outputs
    obj <- read_gcta_hsq( name_out, verbose = verbose )

    # return
    return( obj )
}
