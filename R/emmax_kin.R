# orig: gas_lmm_emmax_kin
# - emmax_kin_bin used to be mandatory, now assumes it's "emmax-kin" on path
# - returned list(runtime, file), new doesn't!

#' Estimate kinship with EMMAX
#'
#' Uses `emmax-kin` with default option to estimate the kinship matrix.
#' The output file will be named `name`.BN.kinf using the input name below (emmax-kin does not allow the input and output names to be different).
#'
#' @param name The shared name of the input plink TPED/TFAM files without extensions.
#' @param emmax_kin_bin The path to the binary executable.
#' Default assumes `emmax-kin` is in the PATH.
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#'
#' @return Nothing (the kinship matrix is not read in; see example below for reading with a different function).
#'
#' @examples 
#' \dontrun{
#' # create kinship matrix estimate (on file)
#' emmax_kin( name )
#'
#' # read file with genio
#' kinship <- genio::read_matrix( name, ext = 'BN.kinf' )
#' }
#' 
#' @seealso
#' [genio::read_matrix()] for reading plain-text matrices.
#' 
#' [plink1_bed_to_tped()] for creating TPED/TFAM files from BED/BIM/FAM files.
#'
#' [require_files_tped()] for requiring that the TPED/TFAM files exist (used internally by `emmax_kin`).
#'
#' [delete_files_tped()] for deleting TPED/TFAM files.
#'
#' [emmax_lmm()] for running GWAS with EMMAX.
#' 
#' [system3()], used (with `ret = FALSE`) for executing EMMAX and error handling.
#' 
#' @export
emmax_kin <- function(
                      name,
                      emmax_kin_bin = 'emmax-kin',
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    
    if ( Sys.which( emmax_kin_bin ) == '' )
        stop('Executable path `emmax_kin_bin` not found!')
    
    # check that plink files are present
    require_files_tped( name )

    # arguments
    # go with default (another option with -s)
    args <- c(
        name,
        '-d',
        10 # precision of digits
    )

    # actual run
    system3( emmax_kin_bin, args, verbose )
}

