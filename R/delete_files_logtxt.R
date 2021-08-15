# for gemma
delete_files_logtxt <- function( name ) {
    # use genio's internal code
    genio:::delete_files_generic( name, 'log.txt' )
}
