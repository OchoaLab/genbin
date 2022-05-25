# name of input for tests
n_ind <- 33
m_loci <- 101
name <- paste0( 'dummy-', n_ind, '-', m_loci, '-0.1' )
# parameter to use in tests
# use something non-default and small
n_pcs <- 3

# write an output to a temporary location
# (no extension)
name_out <- tempfile( 'delete-me-random-test' )

# load `bim` for comparison
bim <- genio::read_bim( name, verbose = FALSE )

check_assoc_data <- function( data, emmax = FALSE ) {
    # check number of rows
    expect_equal( nrow( data ), m_loci )
    
    # compare to bim columns (note `posg` is not in any of the output)
    # emmax only outputs `id`!
    col_names <- if ( emmax ) 'id' else c('chr', 'id', 'pos', 'alt', 'ref')
    for ( col_name in col_names ) {
        expect_equal( data[[ col_name ]], bim[[ col_name ]] )
    }
    
    # these two are extra, not in BIM:
    # specific key columns must exist
    expect_true( all( c('p', 'beta') %in% names( data ) ) )
    # validate p-values
    expect_true( is.numeric( data$p ) )
    expect_true( all( data$p >= 0 ) )
    expect_true( all( data$p <= 1 ) )
    # betas are less restricted
    expect_true( is.numeric( data$beta ) )
}
