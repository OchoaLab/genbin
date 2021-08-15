# load some stuff shared across contexts
source( 'shared.R' )

# tests that require binary (in path)
if ( Sys.which( 'plink1' ) != '' ) {

    test_that( "plink1_bed_to_tped works", {
        # errors on purpose when things are missing
        expect_error( plink1_bed_to_tped() )
        # pass it a file that doesn't actually exist
        expect_error( plink1_bed_to_tped( 'does-not-exist' ) )
        # file exists but has no BED data (fails in binary, not in R)
        expect_error( plink1_bed_to_tped( 'empty', verbose = FALSE ) )
        
        # a successful run
        # nothing gets returned, but tped/tfam files are created
        expect_silent(
            plink1_bed_to_tped( name, name_out, verbose = FALSE )
        )
        
        # check that they exist
        # tests this function too
        expect_silent(
            require_files_tped( name_out )
        )
        
        # cleanup
        # also tests these other functions
        expect_silent(
            delete_files_log( 'empty' )
        )
        expect_silent(
            delete_files_log( name_out )
        )
        expect_silent(
            delete_files_tped( name_out )
        )
    })
}
