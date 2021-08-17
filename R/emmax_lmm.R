# orig: gas_lmm_emmax
# - emmax_bin used to be mandatory, now assumes it's "emmax" on path
# - removed `m_loci` option (for validations)
# - removed `cleanup` option (now we must apply cleanup outside!)
# - returned list(runtime), new doesn't!


#' Run EMMAX and returns table of association statistics.
#'
#' A wrapper for running EMMAX genetic association test followed by reading of the results by [read_emmax_ps()].
#'
#' @param name The shared name of the input plink TPED/TFAM files without extensions.
#' @param file_kinship The path to the kinship matrix file.
#' @param name_phen The base name of the phenotype file without .phen extension (default same as input `name`).
#' @param name_out The base name of the output statistics file (default same as input `name`), which gets extension ".ps" added automatically.
#' @param maf Optional vector of allele frequencies (misnamed, these cannot be *minor* allele frequencies or nothing gets corrected), used to correct signs of regression coefficients (EMMAX reports them in terms of the major allele, not the original allele).  If missing, no corrections are applied.
#' @param emmax_bin The path to the binary executable.
#' Default assumes `emmax` is in the PATH.
#' @param verbose If `TRUE` (default), prints the command line before it is executed.
#'
#' @return The table of genetic association statistics, as a `tibble`, read with [read_emmax_ps()] (see that for more info).
#'
#' @examples 
#' \dontrun{
#' data <- emmax_lmm( name, file_kinship, name_out )
#' }
#' 
#' @seealso
#' [plink1_bed_to_tped()] for creating TPED/TFAM files from BED/BIM/FAM files.
#'
#' [require_files_tped()] for requiring that the TPED/TFAM files exist (used internally by `emmax_lmm`).
#'
#' [delete_files_tped()] for deleting TPED/TFAM files.
#'
#' [emmax_kin()] for estimating the kinship matrix with EMMAX.
#' 
#' [read_emmax_ps()] for parsing the output of EMMAX.
#'
#' [delete_files_emmax_lmm()] and [delete_files_log()] for deleting the EMMAX output files.
#'
#' [system3()], used (with `ret = FALSE`) for executing EMMAX and error handling.
#' 
#' @export
emmax_lmm <- function(
                      name,
                      file_kinship,
                      name_phen = name,
                      name_out = name,
                      maf = NULL,
                      emmax_bin = 'emmax',
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    if ( missing( file_kinship ) )
        stop('Kinship matrix file path (file_kinship) is required!')
    
    if ( Sys.which( emmax_bin ) == '' )
        stop('Executable path `emmax_bin` not found!')
    
    # check that all input files are present
    require_files_tped( name )
    genio::require_files_phen(name)
    # require the input kinship file
    if ( !file.exists( file_kinship ) )
        stop('Required file is missing: ', file_kinship)

    # arguments
    args <- c(
        '-t',
        name,
        '-p',
        paste0( name_phen, '.phen' ),
        '-k',
        file_kinship,
        '-o',
        name_out,
        '-d',
        10 # precision of digits
    )

    # actual run
    system3( emmax_bin, args, verbose )

    # parse output
    data <- read_emmax_ps(
        name,
        maf = maf,
        verbose = verbose
    )
    
    # return this
    return( data )
}
