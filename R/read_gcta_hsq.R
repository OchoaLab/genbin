read_gcta_hsq <- function( file, ext = 'hsq', verbose = TRUE ) {
    if ( missing( file ) )
        stop( '`file` is required!' )

    # add .ext and/or .gz if missing and needed
    file <- genio:::add_ext_read(file, ext)
    
    # announce it if needed
    if (verbose)
        message('Reading: ', file)

    # read table!
    # unfortunately an irregular table
    # this always complains beause last few rows only have 2 columns
    # warning is deferred until first access to data below
    data <- readr::read_tsv(
                       file,
                       col_types = 'cdd'
                   )
    # find herit estimate
    # row of interest
    suppressWarnings( # here happens the warning we want to supress!
        index <- data$Source == 'V(G)/Vp'
    )
    # heritability point estimate
    herit <- data$Variance[ index ]
    # standard error from MVN model
    se <- data$SE[ index ]

    # return this
    return(
        list(
            herit = herit,
            se = se,
            data = data # full table
        )
    )
}
