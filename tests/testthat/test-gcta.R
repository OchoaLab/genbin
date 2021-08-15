# load some stuff shared across contexts
source( 'shared.R' )

# tests that don't require binary

test_that( "read_gcta_mlma works", {
    # expect error when data is missing
    expect_error( read_gcta_mlma() )

    # read an existing file
    expect_silent( data <- read_gcta_mlma( name, verbose = FALSE ) )

    # generic association data checker
    check_assoc_data( data )
})

test_that( "read_gcta_hsq works", {
    # expect error when data is missing
    expect_error( read_gcta_hsq() )
    
    # read an existing file
    expect_silent( obj <- read_gcta_hsq( name, verbose = FALSE ) )
    # validate custom object
    expect_true( is.list( obj ) )
    expect_equal( names( obj ), c('herit', 'se', 'data') )
    expect_true( is.numeric( obj$herit ) )
    expect_equal( length( obj$herit ), 1 )
    expect_true( is.numeric( obj$se ) )
    expect_equal( length( obj$se ), 1 )
    expect_true( is.data.frame( obj$data ) )
})

# use binary in path
if ( Sys.which( 'gcta64' ) != '' ) {
    
    test_that( "gcta_grm works", {
        # errors on purpose when things are missing
        expect_error( gcta_grm() )
        # pass it a file that doesn't actually exist
        expect_error( gcta_grm( 'does-not-exist' ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( gcta_grm( 'empty', verbose = FALSE ) )
        
        # a successful run
        # nothing gets returned, but GRM files are created
        expect_silent( gcta_grm( name, name_out, verbose = FALSE ) )

        # validate outputs by parsing them with `genio`
        expect_silent(
            data <- genio::read_grm( name_out, verbose = FALSE )
        )
        # limited validation as read_grm makes sure things are consistent anyway
        expect_equal( nrow( data$kinship ), n_ind )
        
        # cleanup
        unlink( 'empty.grm.id' ) # only this one gets created for "empty" case
        # also tests this other function
        expect_silent(
            delete_files_log( name_out )
        )
        # NOTE: don't delete GRM yet, need in next step
    })

    test_that( "gcta_pca works", {
        # errors on purpose when things are missing
        expect_error( gcta_pca() )
        # pass it a file that doesn't actually exist
        expect_error( gcta_pca( 'does-not-exist' ) )
        
        # a successful run, actually requires GRM files from previous step
        # nothing gets returned, but eigenvec/val files are created
        expect_silent( gcta_pca( name_out, name_out, n_pcs = n_pcs, verbose = FALSE ) )

        # validate outputs by parsing them with `genio`
        expect_silent(
            data <- genio::read_eigenvec( name_out, verbose = FALSE )
        )
        expect_equal( ncol( data$eigenvec ), n_pcs )
        expect_equal( nrow( data$eigenvec ), n_ind )
        
        # cleanup
        expect_silent(
            delete_files_log( name_out )
        )
        # NOTE: don't delete GRM and eigenvec/val yet, need in next step
    })

    test_that( "gcta_mlma works", {
        # errors on purpose when things are missing
        expect_error( gcta_mlma() )
        # pass it a file that doesn't actually exist
        expect_error( gcta_mlma( 'does-not-exist' ) )
        
        # a successful run, actually requires GRM files from previous step
        # nothing gets returned, but eigenvec/val files are created
        expect_silent(
            data <- gcta_mlma(
                name,
                name_grm = name_out,
                name_out = name_out,
                verbose = FALSE
            )
        )
        # generic association data checker
        check_assoc_data( data )
        
        # cleanup
        expect_silent(
            delete_files_log( name_out )
        )
        expect_silent(
            delete_files_pca( name_out )
        )
        expect_silent(
            delete_files_gcta_mlma( name_out )
        )
        # NOTE: don't delete GRM yet, need in next step
    })

    test_that( "gcta_reml works", {
        # errors on purpose when things are missing
        expect_error( gcta_reml() )
        # pass it a file that doesn't actually exist
        expect_error( gcta_reml( 'does-not-exist' ) )
        
        # a successful run, actually requires GRM files from previous step
        expect_silent(
            obj <- gcta_reml(
                name,
                name_grm = name_out,
                name_out = name_out,
                verbose = FALSE
            )
        )
        
        # validate custom object
        expect_true( is.list( obj ) )
        expect_equal( names( obj ), c('herit', 'se', 'data') )
        expect_true( is.numeric( obj$herit ) )
        expect_equal( length( obj$herit ), 1 )
        expect_true( is.numeric( obj$se ) )
        expect_equal( length( obj$se ), 1 )
        expect_true( is.data.frame( obj$data ) )

        # cleanup
        expect_silent(
            genio::delete_files_grm( name_out )
        )
        expect_silent(
            delete_files_gcta_hsq( name_out )
        )
        expect_silent(
            delete_files_log( name_out )
        )
    })
}
