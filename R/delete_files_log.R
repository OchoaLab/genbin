#' Delete LOG file
#'
#' This function deletes a standard log file (`log` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `log`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_log("data")
#' }
#'
#' @export
delete_files_log <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'log' )
}
