#' Run a system command quietly unless there's errors
#'
#' A wrapper around [system2()] with some modified behaviors for error cases.
#' When the command is successful, all STDOUT/STDERR output from the binary is omitted (assumes it is useless most of the time).
#' When the command fails, by default the R command stops, showing the full STDOUT/STDERR output as the error message.
#' However, when `ret = TRUE` the full STDOUT/STDERR output is returned as a string, and the return value is returned as the "status" attribute (just as [system2()] returns it, see that for more info).
#' The `ret = TRUE` case tries to avoid producing errors and warnings, allowing for error recovery, though in some cases this is unavoidable (for example, when "command" doesn't exist).
#'
#' @param command The command name, passed to [system2()].
#' @param args Optional arguments, passed to [system2()].
#' @param verbose If `TRUE` (default), prints the command line before it is executed, otherwise it is ommitted.
#' @param ret If `TRUE`, returns STDOUT/STDERR output as a string vector, with return value as the "status" attribute, just as [system2()] returns it when its options are set to `stdout = TRUE` and `stderr = TRUE`.
#' If `FALSE` (default), nothing is returned, and execution is quiet if successful and stops with full STDOUT/STDERR output if unsuccessful.
#'
#' @return Nothing if `ret = FALSE` (default), otherwise the STDOUT/STDERR output with return value as the "status" attribute (see `ret` option above).
#'
#' @examples
#' # an example where nothing really happens and nothing is returned
#' system3( 'ls', '-lh' )
#'
#' # an example that returns the output of `ls`
#' # (detailed table of files in current dir)
#' out <- system3( 'ls', '-lh', ret = TRUE )
#'
#' # error handling is the cool part!
#'
#' # passing a command that doesn't exist produces an error no matter what
#' try( system3( 'flmsdmfr' ) )
#' try( out <- system3( 'flmsdmfr', ret = TRUE ) )
#'
#' # passing a good command with bad arguments, or other behaviors that lead the 
#' # command to start executing but fail and return a non-zero exit status makes
#' # `system3` fail by default, and output STDOUT/STDERR as the error message...
#' try( system3( 'ls', 'file-that-doesnt-exist' ) )
#' 
#' # ... but not if `ret = TRUE`, allowing for easier error recovery by examining
#' # its output.
#' out <- system3( 'ls', 'file-that-doesnt-exist', ret = TRUE )
#' # error status is this attribute:
#' attr( out, "status" )
#' 
#' @seealso
#' [system2()]
#' 
#' @export
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
