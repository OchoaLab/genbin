# orig: gas_lmm_emmax_kin
# - emmax_kin_bin used to be mandatory, now assumes it's "emmax-kin" on path
# - returned list(runtime, file), new doesn't!

# this step creates kinship matrix only
# creates $name.BN.kinf
# NOTE: binary doesn't let me change name from input (there's no `name_out` option)
emmax_kin <- function(
                      name,
                      emmax_kin_bin = 'emmax-kin',
                      verbose = TRUE
                      ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    
    if ( Sys.which( emmax_kin_bin ) == '' )
        stop('Executable path `emmax_kin_bin` not found!')
    
    # check that plink files are present
    require_files_tped( name )

    # arguments
    # go with default (another option with -s)
    args <- c(
        name,
        '-d',
        10 # precision of digits
    )

    # actual run
    system3( emmax_kin_bin, args, verbose )
}

