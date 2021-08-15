# wrapper around BOLT to behave like other tests
# NOTE: requires plink files to have been made first!

# orig: gas_lmm_bolt
# - bolt_bin was required, now defaults to bolt on path
# - param `threads = 1`, new is 0
# - returned list(runtime), new doesn't!
# - used to create log, now it doesn't
# - other output used to be name_out.bolt.stats.txt, now it's name_out.bolt.txt
# - removed option `m_loci` (for validations)

# since the goal is benchmarking, threads = 1 is used to have a good time comparison
# phen will be always passed through FAM here, for simplicity
bolt_lmm <- function(
                     name,
                     name_out = name,
                     bolt_bin = 'bolt',
                     threads = 0,
                     verbose = TRUE
                     ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( bolt_bin ) == '' )
        stop('Executable path `bolt_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads( threads )
    
    # check that plink files are present
    genio::require_files_plink( name )

    # the arguments that are always used
    args <- c(
        '--lmm',
        '--bfile',
        name,
        '--phenoUseFam',
        '--LDscoresUseChip',
        '--statsFile',
        paste0( name_out, '.bolt.txt' ),
        '--lmmForceNonInf', # so columns are never missing!
        '--maxMissingPerSnp', 1, # so table is always complete no matter what
        '--maxMissingPerIndiv', 1, # ditto
        '--numThreads',
        threads
    )
    
    # actual run
    system3( bolt_bin, args, verbose )

    # parse output
    data <- read_bolt_lmm( name_out, verbose = verbose )

    # return this
    return( data )
}

