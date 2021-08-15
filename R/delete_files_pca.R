# old used to delete .log, now that's separate

delete_files_pca <- function( name ) {
    # use genio's internal code
    genio:::delete_files_generic( name, c('eigenvec', 'eigenval') )
}
