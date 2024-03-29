#' Read `plink2 --hardy` output table
#'
#' Parses the output generated by `plink2` with option `--hardy` (Hardy-Weinberg test).
#' Returned table has column names standardized for convenience.
#' Validated with plink2 version "v2.00a3LM AVX2 Intel (4 Aug 2021)".
#'
#' @param file The file path to read, missing the extension.
#' @param ext The expected file extension.
#' (In this case, you cannot set to `NA` to prevent adding any extension to `file`.)
#' The default extension "hardy" agrees with the output of [plink_hardy()].
#' @param verbose If `TRUE` (default) function reports the path of the file being loaded (after autocompleting the extensions).
#'
#' @return The table as a `tibble`.
#' Original names (as they appear in the header line of the file) are modified by lowercasing all, followed by these specific mappings to ensure that columns shared by BIM table have the same names as those returned by [genio::read_bim()], and the test p-value is "p" ("orig" -> "new"):
#' - "#chrom" -> "chr"
#' - "a1" -> "ref"
#' - "ax" -> "alt"
#' - "midp" -> "p" if present (in outputs with option "midp" this column replaces "p")
#'
#' @examples 
#' \dontrun{
#' data <- read_plink_hardy( file )
#' }
#'
#' @seealso
#' [plink_hardy()] wrapper for executing `plink2 --hardy` and reading the results.
#' 
#' @export
read_plink_hardy <- function( file, ext = 'hardy', verbose = TRUE ) {
    if ( missing( file ) )
        stop( '`file` is required!' )

    # construct full path, assuming nothing is NA
    file <- paste0( file, '.', ext )
    
    # announce it if needed
    if (verbose)
        message('Reading: ', file)
    
    # read table!
    data <- readr::read_tsv(
                       file,
                       col_types = 'cccciiiddd'
                   )
    
    # normalize column names
    # just lowercasing gets us far!
    names( data ) <- tolower( names( data ) )
    # extra transforms
    names( data )[ names( data ) == '#chrom' ] <- 'chr'
    names( data )[ names( data ) == 'a1' ] <- 'ref'
    names( data )[ names( data ) == 'ax' ] <- 'alt'
    # this one is only present if midp option was used, otherwise the column is already called "p"
    if ( 'midp' %in% names( data ) )
        names( data )[ names( data ) == 'midp' ] <- 'p'
    
    # return tibble
    return( data )
}
