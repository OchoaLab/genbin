# original: gas_lmm_gcta_pca
# - gcta_bin was required, now defaults to gcta64 on path
# - removed `debug` option
# - added `name_out` option, default used to be `paste0( name, '-n_pcs_', n_pcs )`
# - returned list(runtime), new doesn't!

# this step estimates the PCs only
# creates name_out.eigenvec and name_out.eigenval
# http://cnsgenomics.com/software/gcta/#PCA
gcta_pca <- function(
                     name,
                     name_out = name,
                     n_pcs = 10,
                     gcta_bin = 'gcta64',
                     threads = 0,
                     verbose = TRUE
                     ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    # don't do anything if n_pcs == 0
    if ( n_pcs == 0 )
        return()
    
    if ( Sys.which( gcta_bin ) == '' )
        stop('Executable path `gcta_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    
    # check that GRM files are present
    genio::require_files_grm(name)

    args <- c(
        '--grm',
        name,
        '--pca',
        n_pcs,
        '--out',
        name_out,
        '--thread-num',
        threads
    )
    
    # actual run
    system3( gcta_bin, args, verbose )
}

