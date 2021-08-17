# old used to delete .log, now that's separate

#' Delete `plink2 --glm` output
#'
#' This function deletes the `plink2 --glm` output file (`PHENO1.glm.linear` extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
#'
#' @param file The file path (excluding extension `PHENO1.glm.linear`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_plink_glm("data")
#' }
#'
#' @seealso
#' [plink_glm()]
#' 
#' @export
delete_files_plink_glm <- function( file ) {
    # use genio's internal code
    genio:::delete_files_generic( file, 'PHENO1.glm.linear' )
}

