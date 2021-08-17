#' Delete EMMAX outputs
#'
#' This function deletes each of the EMMAX output files (`reml`, `ps` extensions) given the shared base file path, warning if any of the files did not exist or if any were not successfully deleted.
#'
#' @param file The shared file path (excluding extensions: `reml`, `ps`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_emmax_lmm("data")
#' }
#'
#' @seealso
#' [emmax_lmm()]
#'
#' [delete_files_log()]
#' 
#' @export
delete_files_emmax_lmm <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, c('reml', 'ps') )
}
