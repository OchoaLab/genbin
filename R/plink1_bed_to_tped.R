# orig: plink_bed_to_tped
# - plink_bin was required, now defaults to plink1 on path
# - used to remove *.log and *.nosex automatically, not it doesn't

plink1_bed_to_tped <- function(
                               name,
                               name_out = name,
                               plink1_bin = 'plink1',
                               verbose = TRUE
                               ) {
    if ( missing( name ) )
        stop('Input plink file path (name, without extension) is required!')
    
    if ( Sys.which( plink1_bin ) == '' )
        stop('Executable path `plink1_bin` not found!')
    
    # check that plink files are present
    genio::require_files_plink( name )

    # arguments
    args <- c(
        '--bfile',
        name,
        '--recode',
        'transpose',
        '12',
        '--out',
        name_out,
        '--silent',
        '--allow-no-sex'
    )

    # actual run
    system3( plink1_bin, args, verbose )
}

