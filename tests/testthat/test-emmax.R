# load some stuff shared across contexts
source( 'shared.R' )

# shared across tests
file_emmax_kin <- paste0( name, '.BN.kinf' )

# these tests require us to use MAF to correct signs
# compute them correctly for a realistic test
obj <- genio::read_plink( name, verbose = FALSE )
maf <- rowMeans( obj$X, na.rm = TRUE ) / 2

# tests that don't require binary

test_that( "read_emmax_ps works", {
    # expect error when data is missing
    expect_error( read_emmax_ps() )

    # read an existing file
    expect_silent( data <- read_emmax_ps( name, verbose = FALSE ) )

    # generic association data checker
    check_assoc_data( data, emmax = TRUE )

    # repeat test correcting for MAFs the right way
    expect_silent( data <- read_emmax_ps( name, maf = maf, verbose = FALSE ) )
    check_assoc_data( data, emmax = TRUE )
})

# use binary in path
if ( Sys.which( 'emmax-kin' ) != '' ) {
    
    test_that( "emmax_kin works", {
        # errors on purpose when things are missing
        expect_error( emmax_kin() )
        # pass it a file that doesn't actually exist
        expect_error( emmax_kin( 'does-not-exist' ) )

        # "empty" causes an error in plink and gcta, but not gemma or emmax!
        ## # file exists but has no BED data (fails in binary, not in R)
        ## expect_error( emmax_kin( 'empty', verbose = FALSE ) )

        # a successful run
        # nothing gets returned, but kinship file is created
        # (actually it already existed, but emmax won't let me set a different output so it gets overwritten teach time)
        expect_silent( emmax_kin( name, verbose = FALSE ) )
        
        # validate outputs by parsing them with `genio`
        expect_silent(
            kinship <- genio::read_matrix( file_emmax_kin, ext = NA, verbose = FALSE )
        )
        # a very plain matrix, few tests:
        expect_true( isSymmetric( kinship ) )
        expect_equal( nrow( kinship ), n_ind )
        
        # cleanup: nothing (no log here)
        # NOTE: don't delete kinship yet, need in next step
    })
}

if ( Sys.which( 'emmax' ) != '' ) {
    
    test_that( "emmax_lmm works", {
        # errors on purpose when things are missing
        expect_error( emmax_lmm() )
        expect_error( emmax_lmm( name = name ) )
        expect_error( emmax_lmm( file_kinship = file_emmax_kin ) )
        # pass it a file that doesn't actually exist
        expect_error( emmax_lmm( 'does-not-exist', file_emmax_kin ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( emmax_lmm( 'empty', file_emmax_kin, verbose = FALSE ) )
        
        # successful run
        expect_silent(
            data <- emmax_lmm( name, file_emmax_kin, name_out = name_out, verbose = FALSE )
        )
        # generic association data checker
        check_assoc_data( data, emmax = TRUE )

        # with MAF
        expect_silent(
            data <- emmax_lmm( name, file_emmax_kin, maf = maf, name_out = name_out, verbose = FALSE )
        )
        # generic association data checker
        check_assoc_data( data, emmax = TRUE )

        # cleanup
        delete_files_log( name_out )
        delete_files_emmax_lmm( name_out )
        unlink( file_emmax_kin )
    })
}
