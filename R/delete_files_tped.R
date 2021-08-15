exts_tped <- c('tped', 'tfam')

delete_files_tped <- function(name) {
    genio:::delete_files_generic( name, exts_tped )
}
