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
            lines_log <- read_lines( file_gcta_log )
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

