# some annoying helper functions
# emmax is very old and only works with obsolete and custom formats, which is so annoying!

# orig: gas_lmm_emmax
# - emmax_bin used to be mandatory, now assumes it's "emmax" on path
# - removed `m_loci` option (for validations)
# - removed `cleanup` option (now we must apply cleanup outside!)
# - returned list(runtime), new doesn't!

emmax_lmm <- function(
                      name,
                      file_kinship,
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
        paste0(name, '.phen'),
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
