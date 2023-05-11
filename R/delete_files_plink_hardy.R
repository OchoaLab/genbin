#' Delete `plink2 --hardy` output
#'
#' This function deletes the `plink2 --hardy` output file (`hardy` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `hardy`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_plink_hardy("data")
#' }
#'
#' @seealso
#' [plink_hardy()]
#' 
#' @export
delete_files_plink_hardy <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'hardy' )
}

