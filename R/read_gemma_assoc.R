read_gemma_assoc <- function( file, ext = 'assoc.txt', verbose = TRUE ) {
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
                       col_types = 'cciiccdddddd'
                   )

    # normalize column names
    names( data )[ names( data ) == 'rs' ] <- 'id'
    names( data )[ names( data ) == 'ps' ] <- 'pos'
    names( data )[ names( data ) == 'allele1' ] <- 'ref'
    names( data )[ names( data ) == 'allele0' ] <- 'alt'
    names( data )[ names( data ) == 'p_wald' ] <- 'p'
    
    # return tibble
    return( data )
}
