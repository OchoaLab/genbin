# original: gas_plink
# - plink_bin was required, now defaults to plink2 on path
# - option `file_covar` now comes later in order
# - param `threads = 1`, new is 0
# - removed option `m_loci` (for validations)
# - returned list(runtime), new doesn't!
# - return list is now tibble, with full info
#   - pvals -> p
#   - beta_hat -> beta

#' Run `plink2 --glm` and returns table of association statistics.
#'
#' A wrapper for running plink2's genetic association test followed by reading of the results by [read_plink_glm()].
#' The `--glm` option is run with the modifiers `omit-ref` and `hide-covar`, which simplifies outputs.
#' 
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions.
#' @param name_phen The base name of the phenotype file without PHEN extension (default same as input `name`).
#' Only the first phenotype (column 3) is used.
#' @param name_out The base name of the output statistics file (default same as input `name`), which gets extension ".PHENO1.glm.linear" added automatically.
#' @param file_covar Optional file path of fixed covariates for GLM.
#' Pass the EIGENVEC file (with extension) to control for population structure using principal components.
#' @param plink_bin The path to the binary executable.
#' Default assumes `plink2` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param ver_older Handles the case of missing covariates appropriately for older plink2 versions.
#' In the newer versions we must include `allow-no-covars` option or plink2 fails; however in older versions we must not include `allow-no-covars` or plink2 fails!
#' @param verbose If `TRUE` (default), prints the command line before it is executed, followed by the the path of the output file being read (after autocompleting the extensions).
#'
#' @return The table of genetic association statistics, as a `tibble`, read with [read_plink_glm()] (see that for more info).
#'
#' @examples 
#' \dontrun{
#' data <- plink_glm( name, name_out = name_out )
#' }
#' 
#' @seealso
#' [read_plink_glm()] for parsing the output of `plink2 --glm`.
#'
#' [delete_files_plink_glm()], [delete_files_log()] for deleting the output of `plink2 --glm`.
#'
#' [system3()], used (with `ret = FALSE`) for executing `plink2` and error handling.
#' 
#' @export
plink_glm <- function(
                      name,
                      name_phen = name,
                      name_out = name,
                      file_covar = NULL,
                      plink_bin = 'plink2',
                      threads = 0,
                      ver_older = FALSE,
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( plink_bin ) == '' )
        stop('Executable path `plink_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )
    genio::require_files_phen( name_phen )
    # manually require file_covar
    if ( !is.null( file_covar ) && !file.exists( file_covar ) )
        stop('`file_covar` does not exist!')
    
    # the arguments that are always used
    args <- c(
        '--silent',
        '--bfile',
        name,
        '--pheno',
        paste0( name_phen, '.phen' ),
        '--pheno-col-nums', # this should be default, confused but meh...
        3,
        '--out',
        name_out,
        '--threads',
        threads,
        '--glm',
        'omit-ref',
        'hide-covar'
    )

    if ( is.null( file_covar ) ) {
        # need to add a clarification on newer plink versions
        # however, including 'allow-no-covars' on older plink versions (such as on DCC) itself causes an error!
        # have to add this --glm option in this case (i.e., for zero PCs)
        if ( !ver_older )
            args <- c( args, 'allow-no-covars' )
    } else {
        args <- c( args, '--covar', file_covar )
    }
    
    # actual run
    system3( plink_bin, args, verbose )
    
    # parse output
    data <- read_plink_glm( name_out, verbose = verbose )
    
    # return tibble
    return( data )
}

