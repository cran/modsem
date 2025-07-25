% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generics.R, R/generics_modsem_da.R,
%   R/generics_modsem_pi.R
\name{modsem_predict}
\alias{modsem_predict}
\alias{modsem_predict.modsem_da}
\alias{modsem_predict.modsem_pi}
\title{Predict From \code{modsem} Models}
\usage{
modsem_predict(object, ...)

\method{modsem_predict}{modsem_da}(
  object,
  standardized = FALSE,
  H0 = TRUE,
  newdata = NULL,
  center.data = TRUE,
  ...
)

\method{modsem_predict}{modsem_pi}(object, ...)
}
\arguments{
\item{object}{\code{\link{modsem_da}} object}

\item{...}{Further arguments passed to \code{lavaan::predict};
currently ignored by the \code{\link{modsem_da}} method.}

\item{standardized}{Logical. If \code{TRUE}, return standardized factor scores.}

\item{H0}{Logical. If \code{TRUE} (default), use the baseline model to compute factor scores.
If \code{FALSE}, use the model specified in \code{object}. Using \code{H0 = FALSE} is not recommended!}

\item{newdata}{Compute factor scores based on a different dataset, than the one used in the model estimation.}

\item{center.data}{Should data be centered before computing factor scores? Default is \code{TRUE}.}
}
\value{
* For \code{\link{modsem_pi}}: whatever \code{lavaan::predict()}, which usually 
  returns a matrix of factor scores.
* For \code{\link{modsem_da}}: a numeric matrix \eqn{n \times p}, where \eqn{n} is the number of
  (complete) observations in the dataset, and \eqn{p} the number of latent variables. Each
  column contains either raw or standardised factor scores, depending on the
  \code{standardized} argument.
}
\description{
A generic function (and corresponding methods) that produces predicted
values or factor scores from \code{\link{modsem}} models.
}
\section{Methods (by class)}{
\itemize{
\item \code{modsem_predict(modsem_da)}: Computes (optionally standardised) factor scores via the
regression method using the baseline model unless \code{H0 = FALSE}.

\item \code{modsem_predict(modsem_pi)}: 

}}
\examples{
m1 <- '
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ y1 + y2 + y3

# Inner Model
  Y ~ X + Z + X:Z
'

est_dca <- modsem(m1, oneInt, method = "dblcent")
head(modsem_predict(est_dca))

\dontrun{
est_lms <- modsem(m1, oneInt, method = "lms")
head(modsem_predict(est_lms))
}

}
