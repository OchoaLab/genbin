#' Delete TPED/TFAM files
#'
#' This function deletes each of the transposed plink output files (`tped`, `tfam` extensions) given the shared base file path, warning if any of the files did not exist or if any were not successfully deleted.
#'
#' @param file The shared file path (excluding extensions: `tped`, `tfam`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' delete_files_tped("data")
#' }
#'
#' @seealso
#' [plink1_bed_to_tped()]
#' 
#' @export
delete_files_tped <- function(file) {
    genio:::delete_files_generic( file, c('tped', 'tfam') )
}
