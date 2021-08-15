# orig: delete_files_gcta( herit = FALSE )

exts_gcta_mlma <- c('mlma')

delete_files_gcta_mlma <- function(name) {
    # use genio's internal code
    # list of files that must exist
    genio:::delete_files_generic( name, exts_gcta_mlma )
}
