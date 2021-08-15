# original: gas_plink
# - plink_bin was required, now defaults to plink2 on path
# - option `file_covar` now comes later in order
# - param `threads = 1`, new is 0
# - removed option `m_loci` (for validations)
# - returned list(runtime), new doesn't!
# - return list is now tibble, with full info
#   - pvals -> p
#   - beta_hat -> beta

plink_glm <- function(
                      name,
                      name_phen = name,
                      name_out = name,
                      file_covar = NULL,
                      plink_bin = 'plink2',
                      threads = 0,
                      ver_older = FALSE,
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( plink_bin ) == '' )
        stop('Executable path `plink_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )
    genio::require_files_phen( name_phen )
    # manually require file_covar
    if ( !is.null( file_covar ) && !file.exists( file_covar ) )
        stop('`file_covar` does not exist!')
    
    # the arguments that are always used
    args <- c(
        '--silent',
        '--bfile',
        name,
        '--pheno',
        paste0( name_phen, '.phen' ),
        '--pheno-col-nums', # this should be default, confused but meh...
        3,
        '--out',
        name_out,
        '--threads',
        threads,
        '--glm',
        'omit-ref',
        'hide-covar'
    )

    if ( is.null( file_covar ) ) {
        # need to add a clarification on newer plink versions
        # however, including 'allow-no-covars' on older plink versions (such as on DCC) itself causes an error!
        # have to add this --glm option in this case (i.e., for zero PCs)
        if ( !ver_older )
            args <- c( args, 'allow-no-covars' )
    } else {
        args <- c( args, '--covar', file_covar )
    }
    
    # actual run
    system3( plink_bin, args, verbose )
    
    # parse output
    data <- read_plink_glm( name_out, verbose = verbose )
    
    # return tibble
    return( data )
}

