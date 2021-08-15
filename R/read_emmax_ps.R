# unusual in that MAF is needed to correct signs
read_emmax_ps <- function(
                          file,
                          maf = NULL,
                          ext = 'ps',
                          verbose = TRUE
                          ) {
    if ( missing( file ) )
        stop( '`file` is required!' )

    # add .ext and/or .gz if missing and needed
    file <- genio:::add_ext_read(file, ext)
    
    # announce it if needed
    if (verbose)
        message('Reading: ', file)

    # read table!
    data <- readr::read_tsv(
                       file,
                       col_types = 'cdd',
                       col_names = c('id', 'beta', 'p')
                   )
    
    # emmax-specific: correct beta signs if MAF is available
    if ( !is.null( maf ) ) {
        # make sure lengths match
        if ( length( maf ) != nrow( data ) )
            stop( 'Length of `maf` (', length( maf ), ') must equal number of rows of association table (', nrow( data ), ')!' )
        indexes <- maf < 0.5
        data$beta[ indexes ] <- - data$beta[ indexes ]
    }
    
    # return tibble
    return( data )
}
