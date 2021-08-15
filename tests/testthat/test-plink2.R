# load some stuff shared across contexts
source( 'shared.R' )

# tests that don't require binary

test_that( "read_plink_glm works", {
    # expect error when data is missing
    expect_error( read_plink_glm() )

    # read an existing file
    expect_silent( data <- read_plink_glm( name, verbose = FALSE ) )

    # generic association data checker
    check_assoc_data( data )
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
}
