# load some stuff shared across contexts
source( 'shared.R' )

# shared across tests
file_gemma_kin <- paste0( name_out, '.cXX.txt' )

# tests that don't require binary

test_that( "read_gemma_assoc works", {
    # expect error when data is missing
    expect_error( read_gemma_assoc() )

    # read an existing file
    expect_silent( data <- read_gemma_assoc( name, verbose = FALSE ) )

    # generic association data checker
    check_assoc_data( data )
})

# use binary in path
if ( Sys.which( 'gemma' ) != '' ) {
    
    test_that( "gemma_kin works", {
        # errors on purpose when things are missing
        expect_error( gemma_kin() )
        # pass it a file that doesn't actually exist
        expect_error( gemma_kin( 'does-not-exist' ) )

        # "empty" causes an error in plink and gcta, but not gemma!
        ## # file exists but has no BED data (fails in binary, not in R)
        ## expect_error( gemma_kin( 'empty', verbose = FALSE ) )

        # a successful run
        # nothing gets returned, but kinship file is created
        expect_silent( gemma_kin( name, name_out, verbose = FALSE ) )
        
        # validate outputs by parsing them with `genio`
        expect_silent(
            kinship <- genio::read_matrix( file_gemma_kin, ext = NA, verbose = FALSE )
        )
        # a very plain matrix, few tests:
        expect_true( isSymmetric( kinship ) )
        expect_equal( nrow( kinship ), n_ind )
        
        # cleanup
        delete_files_logtxt( name_out )
        # NOTE: don't delete kinship yet, need in next step
    })

    test_that( "gemma_lmm works", {
        # errors on purpose when things are missing
        expect_error( gemma_lmm() )
        expect_error( gemma_lmm( name = name ) )
        expect_error( gemma_lmm( file_kinship = file_gemma_kin ) )
        # pass it a file that doesn't actually exist
        expect_error( gemma_lmm( 'does-not-exist', file_gemma_kin ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( gemma_lmm( 'empty', file_gemma_kin, verbose = FALSE ) )
        
        # successful run
        expect_silent(
            data <- gemma_lmm( name, file_gemma_kin, name_out = name_out, verbose = FALSE )
        )
        # generic association data checker
        check_assoc_data( data )

        # cleanup
        delete_files_logtxt( name_out )
        delete_files_assoc( name_out )
        unlink( file_gemma_kin )
    })
}
