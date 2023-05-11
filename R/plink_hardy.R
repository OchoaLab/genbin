#' Calculate Hard-Weinberg equilibrium (HWE) p-values and other statistics with plink2
#'
#' A wrapper for plink2's `hardy` option.
#' In addition to the arguments listed below, the executable is run with `--silent` and `--nonfounders` (to use all individuals whether they are labeled as founders or not).
#' 
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions.
#' @param name_out The base name of the output hardy file (default same as input `name`), which gets extensions added automatically.
#' @param midp If `TRUE`, uses mid p-value method.  Default doesn't use it.
#' @param plink_bin The path to the binary executable.
#' Default assumes `plink2` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#'
#' @return The table of HWE statistics, as a `tibble`, read with [read_plink_hardy()] (see that for more info).
#'
#' @examples 
#' \dontrun{
#' # calculate desired statistics
#' data <- plink_hardy( name )
#' }
#' 
#' @seealso
#' [read_plink_hardy()] for reading hardy files.
#' 
#' [delete_files_plink_hardy()] for deleting the hardy outputs.
#'
#' [delete_files_log()] for deleting plink log files.
#' 
#' [system3()], used (with `ret = FALSE`) for executing plink2 and error handling.
#' 
#' @export
plink_hardy <- function(
                        name,
                        name_out = name,
                        midp = FALSE,
                        plink_bin = 'plink2',
                        threads = 0,
                        verbose = TRUE
                        ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    
    if ( Sys.which( plink_bin ) == '' )
        stop('Executable path `plink_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )

    # pass options to hardy as needed
    args <- c()
    if ( midp )
        args <- c( args, 'midp' )
    
    # the arguments that are always used
    # wrap the hardy-specific args
    args <- c(
        '--silent',
        '--bfile',
        name,
        '--nonfounders',
        '--hardy',
        args,
        '--out',
        name_out,
        '--threads',
        threads
    )
    
    # actual run
    system3( plink_bin, args, verbose )

    # parse output
    data <- read_plink_hardy( name_out, verbose = verbose )
    
    # return tibble
    return( data )
}
