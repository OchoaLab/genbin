% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/delete_files_emmax_lmm.R
\name{delete_files_emmax_lmm}
\alias{delete_files_emmax_lmm}
\title{Delete EMMAX outputs}
\usage{
delete_files_emmax_lmm(file)
}
\arguments{
\item{file}{The shared file path (excluding extensions: \code{reml}, \code{ps}).}
}
\value{
Nothing
}
\description{
This function deletes each of the EMMAX output files (\code{reml}, \code{ps} extensions) given the shared base file path, warning if any of the files did not exist or if any were not successfully deleted.
}
\examples{
\dontrun{
delete_files_emmax_lmm("data")
}

}
\seealso{
\code{\link[=emmax_lmm]{emmax_lmm()}}

\code{\link[=delete_files_log]{delete_files_log()}}
}
