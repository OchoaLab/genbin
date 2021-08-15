# output doesn't have a standard extension, so I chose this one
read_bolt_lmm <- function( file, ext = 'bolt.txt', verbose = TRUE ) {
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
                       col_types = 'ccidccdddddd'
                   )
    
    # normalize column names
    # just lowercasing gets us far!
    names( data ) <- tolower( names( data ) )
    # other things to rename
    names( data )[ names( data ) == 'snp' ] <- 'id'
    names( data )[ names( data ) == 'bp' ] <- 'pos'
    names( data )[ names( data ) == 'genpos' ] <- 'posg'
    names( data )[ names( data ) == 'allele1' ] <- 'ref'
    names( data )[ names( data ) == 'allele0' ] <- 'alt'
    names( data )[ names( data ) == 'p_bolt_lmm_inf' ] <- 'p_inf'
    names( data )[ names( data ) == 'p_bolt_lmm' ] <- 'p' # this is the best/main p-value
    
    # return tibble
    return( data )
}
