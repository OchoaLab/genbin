# orig: delete_files_gcta( herit = TRUE )

exts_gcta_hsq <- c('hsq')

delete_files_gcta_hsq <- function( name ) {
    # use genio's internal code
    # list of files that must exist
    genio:::delete_files_generic( name, exts_gcta_hsq )
}

