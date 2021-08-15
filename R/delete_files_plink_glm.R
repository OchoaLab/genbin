# old used to delete .log, now that's separate

exts_plink_glm <- c('PHENO1.glm.linear')

delete_files_plink_glm <- function( name ) {
    # use genio's internal code
    genio:::delete_files_generic( name, exts_plink_glm )
}

