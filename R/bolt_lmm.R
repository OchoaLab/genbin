# orig: gas_lmm_bolt
# - bolt_bin was required, now defaults to bolt on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!
# - used to create log, now it doesn't
# - other output used to be name_out.bolt.stats.txt, now it's name_out.bolt.txt
# - removed option `m_loci` (for validations)

#' Run BOLT-LMM `--lmm` and returns table of association statistics.
#'
#' A wrapper for running BOLT-LMM's genetic association test followed by reading of the results by [read_bolt_lmm()].
#' In addition to the arguments listed below, the executable is run with `--phenoUseFam` (so the phenotype tested can only be the one present in the input FAM file), `--LDscoresUseChip`, `--lmmForceNonInf` (so columns are never missing), and `--maxMissingPerSnp 1 --maxMissingPerIndiv 1` (so full data is used and loci are never missing from table).
#' 
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions (the argument to `--bfile`).
#' @param name_out The base name of the output statistics file (the argument to `--statsFile`; default same as input `name`), which gets extension ".bolt.lmm" added automatically.
#' @param bolt_bin The path to the binary executable.
#' Default assumes `bolt` is in the PATH.
#' @param threads The number of threads to use (the argument to `--numThreads`).
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed, followed by the the path of the output file being read (after autocompleting the extensions).
#'
#' @return The table of genetic association statistics, as a `tibble`, read with [read_bolt_lmm()] (see that for more info).
#'
#' @examples 
#' \dontrun{
#' data <- bolt_lmm( name, name_out )
#' }
#' 
#' @seealso
#' [read_bolt_lmm()] for parsing the output of BOLT-LMM.
#'
#' [delete_files_bolt()] for deleting the output of BOLT-LMM.
#'
#' [system3()], used (with `ret = FALSE`) for executing BOLT-LMM and error handling.
#' 
#' @export
bolt_lmm <- function(
                     name,
                     name_out = name,
                     bolt_bin = 'bolt',
                     threads = 0,
                     verbose = TRUE
                     ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( bolt_bin ) == '' )
        stop('Executable path `bolt_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )

    # the arguments that are always used
    args <- c(
        '--lmm',
        '--bfile',
        name,
        '--phenoUseFam',
        '--LDscoresUseChip',
        '--statsFile',
        paste0( name_out, '.bolt.txt' ),
        '--lmmForceNonInf', # so columns are never missing!
        '--maxMissingPerSnp', 1, # so table is always complete no matter what
        '--maxMissingPerIndiv', 1, # ditto
        '--numThreads',
        threads
    )
    
    # actual run
    system3( bolt_bin, args, verbose )

    # parse output
    data <- read_bolt_lmm( name_out, verbose = verbose )

    # return this
    return( data )
}

