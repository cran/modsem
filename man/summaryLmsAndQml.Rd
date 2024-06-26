% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generics_lms_qml.R
\name{summaryLmsAndQml}
\alias{summaryLmsAndQml}
\title{summaryLmsAndQml}
\usage{
summaryLmsAndQml(
  object,
  H0 = TRUE,
  verbose = TRUE,
  r.squared = TRUE,
  digits = 3,
  ...
)
}
\arguments{
\item{object}{modsem object estimated with lms or qml}

\item{H0}{should a null model be estimated (used for comparison)}

\item{verbose}{print progress for the estimation of null model}

\item{r.squared}{calculate R-squared}

\item{digits}{number of digits to print}

\item{...}{additional arguments}
}
\description{
summaryLmsAndQml
}
