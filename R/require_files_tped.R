#' Require that (old) plink transposed files are present
#'
#' This function checks that each of the Plink transposed files (TPED/TFAM extensions) are present, given the shared base file path, stopping with an informative message if any of the files is missing.
#' This function aids troubleshooting, as various downstream external software report missing files differently and sometimes using confusing or obscure messages.
#'
#' @param file The shared file path (excluding extensions `tped`, `tfam`).
#'
#' @return Nothing
#'
#' @examples
#' \dontrun{
#' # to require "data.tped" and "data.tfam", run like this:
#' # (stops if any of the files is missing)
#' require_files_tped("data")
#' }
#'
#' @seealso
#' [plink1_bed_to_tped()] for creating TPED/TFAM files from BED/BIM/FAM files.
#'
#' [emmax_kin()], [emmax_lmm()] for functions that require TPED/TFAM files.
#'
#' @export
require_files_tped <- function( file ) {
    genio:::require_files_generic( file, c('tped', 'tfam') )
}
