# original: gas_lmm_gcta_kin
# - gcta_bin was required, now defaults to gcta64 on path
# - param `threads = 1`, new is 0
# - removed `debug` option
# - returned list(runtime), new doesn't!

# this step creates kinship matrix only
gcta_grm <- function(
                     name,
                     name_out = name,
                     gcta_bin = 'gcta64',
                     threads = 0,
                     verbose = TRUE
                     ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( gcta_bin ) == '' )
        stop('Executable path `gcta_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    
    # check that plink files are present
    genio::require_files_plink(name)

    # arguments
    args <- c(
        '--bfile',
        name,
        '--make-grm',
        '--out',
        name_out,
        '--thread-num',
        threads
    )

    # actual run
    system3( gcta_bin, args, verbose )
}

