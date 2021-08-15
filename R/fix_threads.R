# input is passed number of threads
# return as-is, unless threads are missing (0, NULL, or NA), then autodetecs available threads and returns that
fix_threads <- function(threads) {
    # several obvious missing values should trigger full multithreaded behavior
    if (is.null(threads) || is.na(threads) || threads == 0)
        threads <- parallel::detectCores()
    # return
    return(threads)
}
