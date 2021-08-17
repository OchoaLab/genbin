# original: gas_lmm_gcta_kin
# - gcta_bin was required, now defaults to gcta64 on path
# - param `threads = 1`, new is 0
# - removed `debug` option
# - returned list(runtime), new doesn't!

#' Estimate kinship (GRM) with GCTA
#'
#' Uses `gcta64` with `-grm` and default option to estimate the kinship matrix.
#' The output file will be named `name_out` using the output name below with extensions `grm.bin`, `grm.N.bin`, and `grm.id`.
#'
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions.
#' @param name_out The base name of the output binary GRM files (default same as input `name`), which get extensions (`grm.bin`, `grm.N.bin`, `grm.id`) added automatically.
#' @param gcta_bin The path to the binary executable.
#' Default assumes `gcta64` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#'
#' @return Nothing (the kinship matrix is not read in; see example below for reading with a different function).
#'
#' @examples 
#' \dontrun{
#' # create kinship matrix estimate (on file)
#' gcta_grm( name, name_out )
#'
#' # read file with genio
#' data <- genio::read_grm( name_out )
#' kinship <- data$kinship
#' }
#' 
#' @seealso
#' [genio::read_grm()] for reading binary GRM matrices.
#' 
#' [gcta_mlma()] for running GWAS with GCTA.
#'
#' [gcta_pca()] for estimating PCA from GRM with GCTA.
#'
#' [genio::delete_files_grm()] for deleting GRM files.
#' 
#' [delete_files_log()] for deleting the GCTA log file.
#' 
#' [system3()], used (with `ret = FALSE`) for executing GCTA and error handling.
#' 
#' @export
gcta_grm <- function(
                     name,
                     name_out = name,
                     gcta_bin = 'gcta64',
                     threads = 0,
                     verbose = TRUE
                     ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( gcta_bin ) == '' )
        stop('Executable path `gcta_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    
    # check that plink files are present
    genio::require_files_plink(name)

    # arguments
    args <- c(
        '--bfile',
        name,
        '--make-grm',
        '--out',
        name_out,
        '--thread-num',
        threads
    )

    # actual run
    system3( gcta_bin, args, verbose )
}

