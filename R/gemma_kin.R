# orig: gas_lmm_gemma_kin
# - gemma_bin was required, now defaults to gemma on path
# - param `threads = 1`, new is 0
# - removed `debug` option
# - returned list(runtime, file), new doesn't!

# this step creates kinship matrix only
gemma_kin <- function(
                      name,
                      name_out = name,
                      gemma_bin = 'gemma',
                      threads = 0,
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Plink file path (name, without extension) is required!')
    
    if ( Sys.which( gemma_bin ) == '' )
        stop('Executable path `gemma_bin` not found!')
    
    # several obvious missing values should trigger full multithreaded behavior
    threads <- fix_threads(threads)
    # dirty hack to control threads in GEMMA (for runtime)!
    Sys.setenv('OMP_NUM_THREADS' = threads)
    
    # check that plink files are present
    genio::require_files_plink(name)

    # this is a pain, since the default is annoying that outputs should be elsewhere
    # found out that local paths must have '.' specified, absolute paths need '/' instead
    outdir <- if ( grepl( '^/', name_out ) ) '/' else '.'
    
    # arguments
    # go with default (options with different -gk numbers)
    # ./gemma -bfile [prefix] -gk [num] -o [prefix]
    args <- c(
        '-bfile',
        name,
        '-gk',
        '-o',
        name_out,
        '-outdir',
        outdir,
        '-silence'
    )

    # actual run
    system3( gemma_bin, args, verbose )
    
    # reset, to not influence things outside of this call
    Sys.unsetenv('OMP_NUM_THREADS')
    
    ## # return the path to the file just created (this is the default form):
    ## file_gemma_kin <- paste0(name_out, '.cXX.txt')
}

