# orig: gas_lmm_gemma_kin
# - gemma_bin was required, now defaults to gemma on path
# - param `threads = 1`, new is 0
# - removed `debug` option
# - returned list(runtime, file), new doesn't!

#' Estimate kinship with GEMMA
#'
#' Uses `gemma` with `-gk` and default option to estimate the kinship matrix.
#' The output file will be named `name_out`.cXX.txt using the output name below.
#'
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions.
#' @param name_out The base name of the output kinship file (default same as input `name`), which gets extension ".cXX.txt" added automatically.
#' @param gemma_bin The path to the binary executable.
#' Default assumes `gemma` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#'
#' @return Nothing (the kinship matrix is not read in; see example below for reading with a different function).
#'
#' @examples 
#' \dontrun{
#' # create kinship matrix estimate (on file)
#' gemma_kin( name )
#'
#' # read file with genio
#' kinship <- genio::read_matrix( name, ext = 'cXX.txt' )
#' }
#' 
#' @seealso
#' [genio::read_matrix()] for reading plain-text matrices.
#' 
#' [gemma_lmm()] for running GWAS with GEMMA.
#' 
#' [delete_files_logtxt()] for deleting the GEMMA log file.
#' 
#' [system3()], used (with `ret = FALSE`) for executing GEMMA and error handling.
#' 
#' @export
gemma_kin <- function(
                      name,
                      name_out = name,
                      gemma_bin = 'gemma',
                      threads = 0,
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( gemma_bin ) == '' )
        stop('Executable path `gemma_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    # dirty hack to control threads in GEMMA (for runtime)!
    Sys.setenv('OMP_NUM_THREADS' = threads)
    
    # check that plink files are present
    genio::require_files_plink(name)

    # this is a pain, since the default is annoying that outputs should be elsewhere
    # found out that local paths must have '.' specified, absolute paths need '/' instead
    outdir <- if ( grepl( '^/', name_out ) ) '/' else '.'
    
    # arguments
    # go with default (options with different -gk numbers)
    # ./gemma -bfile [prefix] -gk [num] -o [prefix]
    args <- c(
        '-bfile',
        name,
        '-gk',
        '-o',
        name_out,
        '-outdir',
        outdir,
        '-silence'
    )

    # actual run
    system3( gemma_bin, args, verbose )
    
    # reset, to not influence things outside of this call
    Sys.unsetenv('OMP_NUM_THREADS')
    
    ## # return the path to the file just created (this is the default form):
    ## file_gemma_kin <- paste0(name_out, '.cXX.txt')
}

