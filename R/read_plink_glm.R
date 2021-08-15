read_plink_glm <- function( file, pheno = 'PHENO1', ext = 'glm.linear', verbose = TRUE ) {
    if ( missing( file ) )
        stop( '`file` is required!' )

    # construct full path, assuming nothing is NA
    file <- paste0( file, '.', pheno, '.', ext )
    
    # announce it if needed
    if (verbose)
        message('Reading: ', file)
    
    # read table!
    data <- readr::read_tsv(
                       file,
                       col_types = 'ciccccciddddc'
                   )
    
    # normalize column names
    # just lowercasing gets us far!
    names( data ) <- tolower( names( data ) )
    # extra transforms
    names( data )[ names( data ) == '#chrom' ] <- 'chr'
    # ref/alt are switched, why!!!  (who is wrong here?)
    # (compared to `genio::read_bim`)
    data[ , c('ref', 'alt') ] <- data[ , c('alt', 'ref') ]
    
    # return tibble
    return( data )
}
