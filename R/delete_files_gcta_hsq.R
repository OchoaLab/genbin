# orig: delete_files_gcta( herit = TRUE )

#' Delete GCTA REML output
#'
#' This function deletes the GCTA REML output file (`hsq` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `hsq`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_gcta_hsq("data")
#' }
#'
#' @seealso
#' [gcta_reml()]
#' 
#' @export
delete_files_gcta_hsq <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'hsq' )
}

