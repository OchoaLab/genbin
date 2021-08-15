# orig: herit_lmm_gcta
# - gcta_bin was required, now defaults to gcta64 on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!

# since the goal is benchmarking, threads = 1 is used to have a good time comparison
gcta_reml <- function(
                      name,
                      name_grm = name,
                      name_phen = name,
                      name_out = name,
                      gcta_bin = 'gcta64',
                      threads = 0,
                      verbose = TRUE
                      ) {
    if (missing(name))
        stop('Input file path (name, without extension; default for GRM, PHEN, and output files) is required!')
    
    if ( Sys.which( gcta_bin ) == '' )
        stop('Executable path `gcta_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    
    # check that GRM and phen files are present
    genio::require_files_phen( name_phen )
    genio::require_files_grm( name_grm )

    # the arguments that are always used
    args <- c(
        '--reml',
        '--grm',
        name_grm,
        '--pheno',
        paste0( name_phen, '.phen' ),
        '--out',
        name_out,
        '--thread-num',
        threads
    )

    # actual run
    system3( gcta_bin, args, verbose )

    # parse outputs
    obj <- read_gcta_hsq( name_out, verbose = verbose )

    # return
    return( obj )
}
