#' Delete GEMMA LOG file
#'
#' This function deletes a GEMMA log file (`log.txt` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `log.txt`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_logtxt("data")
#' }
#'
#' @export
delete_files_logtxt <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'log.txt' )
}
