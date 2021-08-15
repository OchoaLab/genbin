# load some stuff shared across contexts
source( 'shared.R' )

# tests that don't require binary

test_that( "read_bolt_lmm works", {
    # expect error when data is missing
    expect_error( read_bolt_lmm() )

    # read an existing file
    expect_silent( data <- read_bolt_lmm( name, verbose = FALSE ) )

    # generic association data checker
    check_assoc_data( data )
})

# use binary in path
if ( Sys.which( 'bolt' ) != '' ) {
    
    test_that( "bolt_lmm works", {
        # errors on purpose when things are missing
        expect_error( bolt_lmm() )
        # pass it a file that doesn't actually exist
        expect_error( bolt_lmm( 'does-not-exist' ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( bolt_lmm( 'empty', verbose = FALSE ) )
        
        # successful run
        expect_silent(
            data <- bolt_lmm( name, name_out = name_out, verbose = FALSE )
        )
        # generic association data checker
        check_assoc_data( data )
        
        # cleanup
        delete_files_bolt( 'empty' )
        delete_files_bolt( name_out )
    })
}
