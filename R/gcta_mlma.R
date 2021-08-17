# original: gas_lmm_gcta
# - gcta_bin was required, now defaults to gcta64 on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!
# - added option `file_covar`
# - removed `name_pcs` and `n_pcs` (use `file_covar = paste0( name_pcs, '-n_pcs_', n_pcs, '.eigenvec' )` instead)
# - removed option `m_loci` (for validations)
# - return list is now tibble, with full info
#   - pvals -> p
#   - beta_hat -> beta

#' Run GCTA MLMA and returns table of association statistics.
#'
#' A wrapper for running GCTA genetic association test followed by reading of the results by [read_gcta_mlma()].
#' If GCTA returns with a non-zero status, the wrapper inspects STDOUT/STDERR and the log file for messages about non-invertible matrices or convergence failures (cases encountered often when an excessive number of covariates is provided), and returns `NULL` for those cases without errors or warnings in R (all other failures make the wrapper stop with an error).
#'
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions.
#' @param name_grm The shared name of the input binary GRM files without extensions (default same as input `name`).
#' @param name_phen The base name of the phenotype file without PHEN extension (default same as input `name`).
#' @param name_out The base name of the output statistics file (default same as input `name`), which gets extension ".mlma" added automatically.
#' @param file_covar Optional file path of fixed covariates.
#' @param gcta_bin The path to the binary executable.
#' Default assumes `gcta64` is in the PATH.
#' @param threads The number of threads to use.
#' The values 0 (default), NA, or NULL use all threads available (the output of [parallel::detectCores()]).
#' @param verbose If `TRUE` (default), prints the command line before it is executed, followed by the the path of the output file being read (after autocompleting the extensions).
#'
#' @return The table of genetic association statistics, as a `tibble`, read with [read_gcta_mlma()] (see that for more info).
#' Certain errors in the binary (see above) cause `NULL` to be returned.
#'
#' @examples 
#' \dontrun{
#' data <- gcta_mlma( name, name_out )
#' }
#' 
#' @seealso
#' [gcta_grm()] for estimating the kinship (GRM) matrix with GCTA.
#' 
#' [read_gcta_mlma()] for parsing the output of GCTA MLMA.
#'
#' [delete_files_gcta_mlma()] and [delete_files_log()] for deleting the GCTA output files.
#'
#' [system3()], used (with `ret = FALSE`) for executing GCTA and error handling.
#' 
#' @export
gcta_mlma <- function(
                     name,
                     name_grm = name,
                     name_phen = name,
                     name_out = name,
                     file_covar = NULL,
                     gcta_bin = 'gcta64',
                     threads = 0,
                     verbose = TRUE
                     ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')

    if ( Sys.which( gcta_bin ) == '' )
        stop('Executable path `gcta_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )
    genio::require_files_phen( name_phen )
    genio::require_files_grm( name_grm )
    
    # the arguments that are always used
    args <- c(
        '--mlma',
        '--bfile',
        name,
        '--grm',
        name_grm,
        '--pheno',
        paste0( name_phen, '.phen' ),
        '--out',
        name_out,
        '--thread-num',
        threads
    )

    if ( !is.null( file_covar ) )
        args <- c( args, '--qcovar', file_covar )
    
    # actual run
    out <- system3( gcta_bin, args, verbose, ret = TRUE )
    
    # this is command return value
    ret_val <- attr(out, 'status')

    if ( !is.null(ret_val) ) {
        # there was some error
        # some errors we want to be able to continue from
        # NOTE: these are all errors due to there being too many covariates (and not due to missing inputs or something else that actually matters).  As in some tests we push the number of PCs to be very large, we want to allow testing while allowing for problems being sometimes undefined (returning undefined values but without fatal interruptions)
        errors_continue <- FALSE # default state
        # if this message is in output, we want to keep going
        message_continue <- "Error: the information matrix is not invertible." # complete line match
        # partial line matches in log file
        messages_continue_log <- c(
            'the X^t * V^-1 * X matrix is not invertible.' ,
            'Error: analysis stopped because more than half of the variance components are constrained.', # partial too
            'Error: Log-likelihood not converged (stop after 100 iteractions).'
        )
        if ( message_continue %in% out ) {
            errors_continue <- TRUE
        } else {
            # check log file (painful but meh)
            file_gcta_log <- paste0( name_out, '.log' )
            # the log better be there! (could cause its own error)
            lines_log <- readr::read_lines( file_gcta_log )
            # get last line only
            last_line_log <- lines_log[ length(lines_log) ]
            # continue if V(G) or V(e) were NaN (nan in particular)
            if ( grepl( 'nan', last_line_log ) ) {
                errors_continue <- TRUE
            } else {
                for (message_continue_log in messages_continue_log) {
                    # these don't necessarily match the very last line, but they're longer messages, so we can check all lines
                    if ( any( grepl( message_continue_log, lines_log, fixed = TRUE ) ) ) {
                        errors_continue <- TRUE
                        break # stop looking for other matches
                    }
                }
            }
        }
        if ( errors_continue ) {
            # create fake empty data to return something
            data <- NULL
        } else {
            # stop and show error:
            stop( paste0( out, collapse = "\n" ) )
        }
    } else {
        # everything was successful
        # parse output (must exist)
        data <- read_gcta_mlma( name_out, verbose = verbose )
    }

    # return this
    return( data )
}

