delete_files_emmax_lmm <- function( name ) {
    # use genio's internal code
    genio:::delete_files_generic( name, c('reml', 'ps') )
}
