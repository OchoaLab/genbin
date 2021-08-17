# orig: delete_files_gcta( herit = FALSE )

#' Delete GCTA MLMA output
#'
#' This function deletes the GCTA MLMA output file (`mlma` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `mlma`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_gcta_mlma("data")
#' }
#'
#' @seealso
#' [gcta_mlma()]
#' 
#' @export
delete_files_gcta_mlma <- function(file) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'mlma' )
}
