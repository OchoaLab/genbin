# load some stuff shared across contexts
source( 'shared.R' )

# check hardy data, similarly to `check_assoc_data` in `shared.R`
check_hardy_data <- function( data ) {
     expect_true( is.data.frame( data ) )
    
    # check number of rows
    expect_equal( nrow( data ), m_loci )
    
    # compare to bim columns (note `posg` is not in any of the output)
    col_names <- c('chr', 'id', 'alt', 'ref')
    for ( col_name in col_names ) {
        expect_equal( data[[ col_name ]], bim[[ col_name ]] )
    }
    
    # these two are extra, not in BIM:
    # specific key columns must exist
    expect_true( 'p' %in% names( data ) )
    # validate p-values
    expect_true( is.numeric( data$p ) )
    expect_true( all( data$p >= 0 ) )
    expect_true( all( data$p <= 1 ) )
}

# tests that don't require binary

test_that( "read_plink_glm works", {
    # expect error when data is missing
    expect_error( read_plink_glm() )

    # read an existing file
    expect_silent( data <- read_plink_glm( name, verbose = FALSE ) )

    # generic association data checker
    check_assoc_data( data )
})

test_that( 'read_plink_hardy works', {
    # expect error when data is missing
    expect_error( read_plink_hardy() )

    # read an existing file
    expect_silent( data <- read_plink_hardy( name, verbose = FALSE ) )
    # check data!
    check_hardy_data( data )

    # repeat with midp version, which has a column with a different name
    name2 <- paste0( name, '.midp' )
    expect_silent( data <- read_plink_hardy( name2, verbose = FALSE ) )
    check_hardy_data( data )
})

# tests that require binary (in path)
if ( Sys.which( 'plink2' ) != '' ) {

    test_that( "plink_pca works", {
        # errors on purpose when things are missing
        expect_error( plink_pca() )
        # pass it a file that doesn't actually exist
        expect_error( plink_pca( 'does-not-exist' ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( plink_pca( 'empty', verbose = FALSE ) )
        
        # a successful run
        # nothing gets returned, but eigenvec/val files are created
        expect_silent( plink_pca( name, name_out, n_pcs = n_pcs, verbose = FALSE ) )

        # validate outputs by parsing them with `genio`
        expect_silent(
            data <- genio::read_eigenvec( name_out, verbose = FALSE )
        )
        expect_equal( ncol( data$eigenvec ), n_pcs )
        expect_equal( nrow( data$eigenvec ), n_ind )
        
        # cleanup
        # also tests this other function
        expect_silent(
            delete_files_log( 'empty' )
        )
        expect_silent(
            delete_files_log( name_out )
        )
        # NOTE: leave eigenvec/val for next test!
    })

    test_that( "plink_glm works", {
        # errors on purpose when things are missing
        expect_error( plink_glm() )
        # pass it a file that doesn't actually exist
        expect_error( plink_glm( 'does-not-exist' ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( plink_glm( 'empty', verbose = FALSE ) )
        
        # a successful run
        # version without PCs
        expect_silent(
            data <- plink_glm(
                name,
                name_out = name_out,
                verbose = FALSE
            )
        )
        expect_equal( nrow( data ), m_loci )
        
        # cleanup
        # also tests this other function
        expect_silent(
            delete_files_log( name_out )
        )
        expect_silent(
            delete_files_plink_glm( name_out )
        )

        # repeat with PCs, using files that should still be there
        # now the association
        expect_silent(
            data <- plink_glm(
                name,
                name_out = name_out,
                file_covar = paste0( name_out, '.eigenvec' ),
                verbose = FALSE
            )
        )
        # generic association data checker
        check_assoc_data( data )

        # repeat again with a non-default maximum VIF
        # repeat with PCs, using files that should still be there
        # now the association
        expect_silent(
            data <- plink_glm(
                name,
                name_out = name_out,
                file_covar = paste0( name_out, '.eigenvec' ),
                vif = 100,
                verbose = FALSE
            )
        )
        # generic association data checker
        check_assoc_data( data )

        # repeat again with a non-default maximum correlation
        # repeat with PCs, using files that should still be there
        # now the association
        expect_silent(
            data <- plink_glm(
                name,
                name_out = name_out,
                file_covar = paste0( name_out, '.eigenvec' ),
                max_corr = 1,
                verbose = FALSE
            )
        )
        # generic association data checker
        check_assoc_data( data )

        # cleanup
        # also tests this other function
        expect_silent(
            delete_files_log( 'empty' )
        )
        expect_silent(
            delete_files_log( name_out )
        )
        expect_silent(
            delete_files_plink_glm( name_out )
        )
        expect_silent(
            delete_files_pca( name_out )
        )
    })

    test_that( "plink_hardy works", {
        # errors on purpose when things are missing
        expect_error( plink_hardy() )
        # pass it a file that doesn't actually exist
        expect_error( plink_hardy( 'does-not-exist' ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( plink_hardy( 'empty', verbose = FALSE ) )
        
        # a successful run
        expect_silent( data <- plink_hardy( name, name_out, verbose = FALSE ) )
        # check data!
        check_hardy_data( data )
        
        # a successful run, midp version
        expect_silent( data <- plink_hardy( name, name_out, midp = TRUE, verbose = FALSE ) )
        # check data!
        check_hardy_data( data )
        
        # cleanup
        # also tests this other function
        expect_silent(
            delete_files_log( 'empty' )
        )
        expect_silent(
            delete_files_log( name_out )
        )
        expect_silent(
            delete_files_plink_hardy( name_out )
        )
    })

}
