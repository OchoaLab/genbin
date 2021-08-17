# orig: plink_bed_to_tped
# - plink_bin was required, now defaults to plink1 on path
# - used to remove *.log and *.nosex automatically, not it doesn't

#' Reformat BED/BIM/FAM to TPED/TFAM
#'
#' Uses `plink1` to perform reformatting (note `plink2` does not have this functionality, as tped/tfam is a very old and obsolete format).
#'
#' @param name The shared name of the input plink BED/BIM/FAM files without extensions.
#' @param name_out The base name of the output TPED/TFAM files without extensions (default same as input `name`).
#' @param plink1_bin The path to the binary executable.
#' Default assumes `plink1` is in the PATH.
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#' 
#' @return Nothing.
#'
#' @examples
#' \dontrun{
#' plink1_bed_to_tped( name )
#' }
#'
#' @seealso
#' [require_files_tped()] for requiring that the TPED/TFAM files exist.
#'
#' [delete_files_tped()] for deleting TPED/TFAM files.
#'
#' [delete_files_log()] for deleting the plink log file.
#' 
#' [emmax_kin()], [emmax_lmm()] for functions that require TPED/TFAM files.
#'
#' @export
plink1_bed_to_tped <- function(
                               name,
                               name_out = name,
                               plink1_bin = 'plink1',
                               verbose = TRUE
                               ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    
    if ( Sys.which( plink1_bin ) == '' )
        stop('Executable path `plink1_bin` not found!')
    
    # check that plink files are present
    genio::require_files_plink( name )

    # arguments
    args <- c(
        '--bfile',
        name,
        '--recode',
        'transpose',
        '12',
        '--out',
        name_out,
        '--silent',
        '--allow-no-sex'
    )

    # actual run
    system3( plink1_bin, args, verbose )
}

