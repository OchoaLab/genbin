#' Delete GEMMA output
#'
#' This function deletes the GEMMA output file (`assoc.txt` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `assoc.txt`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_assoc("data")
#' }
#'
#' @seealso
#' [gemma_lmm()]
#' 
#' @export
delete_files_assoc <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'assoc.txt' )
}
