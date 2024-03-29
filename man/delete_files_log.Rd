% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/delete_files_log.R
\name{delete_files_log}
\alias{delete_files_log}
\title{Delete LOG file}
\usage{
delete_files_log(file)
}
\arguments{
\item{file}{The file path (excluding extension \code{log}).}
}
\value{
Nothing
}
\description{
This function deletes a standard log file (\code{log} extension) given the base file path, warning if the file did not exist or if it was not successfully deleted.
}
\examples{
\dontrun{
delete_files_log("data")
}

}
