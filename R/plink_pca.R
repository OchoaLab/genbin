# original: gas_plink_pca
# - plink_bin was required, now defaults to plink2 on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!

# creates name.eigenvec and name.eigenval
plink_pca <- function(
                      name,
                      name_out = name,
                      n_pcs = 10,
                      maf = 0.1,
                      approx = FALSE,
                      plink_bin = 'plink2',
                      threads = 0,
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    
    # don't do anything if n_pcs == 0
    if ( n_pcs == 0 )
        return()
    
    if ( Sys.which( plink_bin ) == '' )
        stop('Executable path `plink_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )

    # pass options to PCA as needed
    args <- c()
    if (approx)
        args <- c( args, 'approx' )
    
    # the arguments that are always used
    # wrap the PCA-specific args
    args <- c(
        '--silent',
        '--bfile',
        name,
        '--nonfounders',
        '--bad-freqs',
        '--maf',
        maf,
        '--pca',
        args,
        n_pcs,
        '--out',
        name_out,
        '--threads',
        threads
    )
    
    # actual run
    system3( plink_bin, args, verbose )
}

