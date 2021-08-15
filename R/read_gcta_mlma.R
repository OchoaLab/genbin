read_gcta_mlma <- function( file, ext = 'mlma', verbose = TRUE ) {
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
                       col_types = 'cciccdddd'
                   )
    
    # normalize column names
    # just lowercasing gets us far!
    names( data ) <- tolower( names( data ) )
    # other things to rename
    names( data )[ names( data ) == 'snp' ] <- 'id'
    names( data )[ names( data ) == 'bp' ] <- 'pos'
    names( data )[ names( data ) == 'a1' ] <- 'ref'
    names( data )[ names( data ) == 'a2' ] <- 'alt'
    names( data )[ names( data ) == 'b' ] <- 'beta'
    
    # return tibble
    return( data )
}
