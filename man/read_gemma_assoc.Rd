% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_gemma_assoc.R
\name{read_gemma_assoc}
\alias{read_gemma_assoc}
\title{Read GEMMA statistics table}
\usage{
read_gemma_assoc(file, ext = "assoc.txt", verbose = TRUE)
}
\arguments{
\item{file}{The file path to read, possibly missing the extension.}

\item{ext}{The expected file extension.
Set to \code{NA} to prevent adding any extension to \code{file}.
The default "assoc.txt" extension matches what GEMMA generates.}

\item{verbose}{If \code{TRUE} (default) function reports the path of the file being loaded (after autocompleting the extensions).}
}
\value{
The table as a \code{tibble}.
Original names (as they appear in the header line of the file) are modified by these specific mappings to ensure that columns shared by BIM table have the same names as those returned by \code{\link[genio:read_bim]{genio::read_bim()}}, the association p-value is "p", and the regression coefficient is "beta" ("orig" -> "new"):
\itemize{
\item "rs" -> "id"
\item "ps" -> "pos"
\item "allele1" -> "alt"
\item "allele0" -> "ref"
\item "p_wald" -> "p"
}
}
\description{
Parses the output generated by GEMMA (genetic assocation test).
Returned table has column names standardized for convenience.
Validated with GEMMA version 0.98.1.
}
\examples{
\dontrun{
data <- read_gemma_assoc( file )
}

}
\seealso{
\code{\link[=gemma_lmm]{gemma_lmm()}} wrapper for executing GEMMA and reading the results.
}
