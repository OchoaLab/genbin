test_that( "fix_threads works", {
    # the default cases should all work
    # (these values should be the number of cores, which vary by machine)
    expect_true( fix_threads( NULL ) >= 1 )
    expect_true( fix_threads( NA ) >= 1 )
    expect_true( fix_threads( 0 ) >= 1 )
    # higher values should be returned as-is
    for ( i in 1 : 10 ) {
        expect_equal( fix_threads( i ), i )
    }
})

test_that( "system3 works", {
    # try something that should succeed
    # this is OS-specific, but should work on all unixes (boo windows)
    expect_silent( system3( 'ls', verbose = FALSE ) )

    # something where the command runs but there's an error
    expect_error( system3( 'ls', 'flmsdmfr', verbose = FALSE ) )

    # now something that should fail on any reasonable machine
    # this kind of error is different because the command doesn't even exist!
    expect_error( system3( 'flmsdmfr', verbose = FALSE ) )

    # versions that return numbers and don't die (usually)
    # successful
    expect_silent(
        out <- system3( 'ls', verbose = FALSE, ret = TRUE )
    )
    expect_true( is.null( attr(out, 'status') ) )
    # failure of nice kind
    expect_silent(
        out <- system3( 'ls', 'flmsdmfr', verbose = FALSE, ret = TRUE )
    )
    expect_true( !is.null( attr(out, 'status') ) )
    # failure of worst kind
    expect_error(
        system3( 'flmsdmfr', verbose = FALSE, ret = TRUE )
    )
})
