#' Delete BOLT-LMM output
#'
#' This function deletes the BOLT-LMM output file (`bolt.txt` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `bolt.txt`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_bolt("data")
#' }
#'
#' @seealso
#' [bolt_lmm()]
#' 
#' @export
delete_files_bolt <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'bolt.txt' )
}
