# orig: herit_lmm_gcta
# - gcta_bin was required, now defaults to gcta64 on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!

#' Run GCTA REML and return the estimated heritability.
#'
#' A wrapper for running GCTA variance component estimation followed by reading of the results by [read_gcta_hsq()].
#'
#' @inheritParams gcta_mlma
#' @param name The shared default name of the input and output files without extensions.
#' @param name_out The base name of the output variance component file (default same as input `name`), which gets extension ".hsq" added automatically.
#' @param m_pheno The index of the phenotype to analyze.
#' Defaults to the first phenotype in the given phenotype table.
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
                      file_covar = NULL,
                      file_covar_cat = NULL,
                      gcta_bin = 'gcta64',
                      threads = 0,
                      m_pheno = 1,
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
        '--mpheno',
        m_pheno,
        '--out',
        name_out,
        '--thread-num',
        threads
    )

    if ( !is.null( file_covar ) )
        args <- c( args, '--qcovar', file_covar )
    if ( !is.null( file_covar_cat ) )
        args <- c( args, '--covar', file_covar_cat )
    
    # actual run
    system3( gcta_bin, args, verbose )

    # parse outputs
    obj <- read_gcta_hsq( name_out, verbose = verbose )

    # return
    return( obj )
}
