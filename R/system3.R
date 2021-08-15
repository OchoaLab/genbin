# wrapper around system2
# - it doesn't show any outputs when return value is zero/null
# - if there's an error, supresses warning, turns it into error showing full output
# - if we want return values behavior is trickier (see tests), tries not to die for non-successful runs (some extreme cases still die, like if we called a command that doesn't exist at all)
system3 <- function( command, args = character(), verbose = TRUE, ret = FALSE ) {
    # show command about to run
    if ( verbose )
        message( paste0( c( command, args ), collapse = ' ' ) )

    # actual run
    # NOTE: this can stop if the command doesn't exist at all (or other serious errors)
    suppressWarnings(
        out <- system2(
            command,
            args = args,
            stdout = TRUE,
            stderr = TRUE
        )
    )

    # if we just want it returned, do that (and don't die!)
    if ( ret )
        return( out )

    # this is command return value
    ret_val <- attr(out, 'status')

    # stop and show error, if any: 
    if ( !is.null(ret_val) )
        stop( paste0( out, collapse = "\n" ) )
}
