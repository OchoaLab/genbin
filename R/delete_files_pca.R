# old used to delete .log, now that's separate

#' Delete PCA outputs
#'
#' This function deletes each of the standard PCA output files (`eigenvec`, `eigenval` extensions) given the shared base file path, warning if any of the files did not exist or if any were not successfully deleted.
#'
#' @param file The shared file path (excluding extensions: `eigenvec`, `eigenval`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_pca("data")
#' }
#'
#' @seealso
#' [plink_pca()]
#'
#' [delete_files_log()]
#' 
#' @export
delete_files_pca <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, c('eigenvec', 'eigenval') )
}
