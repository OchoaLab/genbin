# orig: gas_lmm_gemma
# - gemma_bin was required, now defaults to gemma on path
# - param `threads = 1`, new is 0
# - removed `debug` option
# - removed `m_loci` option (for validations)
# - removed `cleanup` option (now we must apply cleanup outside!)
# - returned list(runtime), new doesn't!

gemma_lmm <- function(
                      name,
                      file_kinship,
                      name_out = name,
#                      m_loci = NA,
                      gemma_bin = 'gemma',
                      threads = 0,
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    if ( missing( file_kinship ) )
        stop('Kinship matrix file path (file_kinship) is required!')
    
    if ( Sys.which( gemma_bin ) == '' )
        stop('Executable path `gemma_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    # dirty hack to control threads in GEMMA (for runtime)!
    Sys.setenv('OMP_NUM_THREADS' = threads)
    
    # check that plink files are present
    genio::require_files_plink(name)
    # also require the input kinship file
    if ( !file.exists( file_kinship ) )
        stop( 'Required file is missing: ', file_kinship )

    # this is a pain, since the default is annoying that outputs should be elsewhere
    # found out that local paths must have '.' specified, absolute paths need '/' instead
    outdir <- if ( grepl( '^/', name_out ) ) '/' else '.'
    
    # again go with default -lmm test (Wald)
    # ./gemma -bfile [prefix] -k [filename] -lmm [num] -o [prefix]
    args <- c(
        '-bfile',
        name,
        '-k',
        file_kinship,
        '-lmm',
        '-o',
        name_out,
        '-outdir',
        outdir,
        '-silence',
        # added to prevent filters on input
        '-notsnp', # no MAF filter
        '-miss', 1, # no missingness filter
        '-r2', 1 # no LD filter
    )
    
    # actual run
    system3( gemma_bin, args, verbose )
    
    # reset, to not influence things outside of this call
    Sys.unsetenv('OMP_NUM_THREADS')
    
    # parse output
    data <- read_gemma_assoc( name, verbose = verbose )

    ## if (!is.na(m_loci)) {
    ##     # one check before we move on... (debugging)
    ##     m_loci_gas <- nrow( data )
    ##     if( m_loci_gas != m_loci ) {
    ##         message('GEMMA has too few p-values: ', m_loci_gas, ' != ', m_loci, ' ... fixing!')
    ##         # load bim to fix this situation
    ##         bim <- genio::read_bim(name)
    ##         # make sure IDs are unique, would have to do more work otherwise
    ##         if ( length(unique(bim$id)) != length(bim$id) )
    ##             stop('BIM has repeated IDs!  Havent implemented fix for GEMMA missing rows!')
    ##         # sanity check, all of the GEMMA loci should be in BIM
    ##         if ( !all( data$rs %in% bim$id ) )
    ##             stop('GEMMA table has loci missing in BIM!')
    ##         # find matching rows
    ##         indexes <- match(bim$id, data$rs)
    ##         # this stretches the data, with rows full of NA values for missing things!
    ##         # now we're good!
    ##         data <- data[indexes, ]
    ##     }
    ## }
    
    # return this
    return( data )
}
