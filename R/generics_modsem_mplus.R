#' summary for modsem objects
#'
#' @param object modsem object to summarized
#' @param scientific print p-values in scientific notation
#' @param standardize standardize estimates
#' @param ci print confidence intervals
#' @param digits number of digits to print
#' @param loadings print loadings
#' @param regressions print regressions
#' @param covariances print covariances
#' @param intercepts print intercepts
#' @param variances print variances
#' @param ... arguments passed to other functions
#' @rdname summary
#' @export
summary.modsem_mplus <- function(object,
                                 scientific = FALSE,
                                 standardize = FALSE,
                                 ci = FALSE,
                                 digits = 3,
                                 loadings = TRUE,
                                 regressions = TRUE,
                                 covariances = TRUE,
                                 intercepts = TRUE,
                                 variances = TRUE,
                                 ...) {
  if (standardize) object$parTable <- standardized_estimates(object)
  object$format <- list(digits = digits,
                        scientific = scientific,
                        ci = ci,
                        loadings = loadings,
                        regressions = regressions,
                        covariances = covariances,
                        intercepts = intercepts,
                        variances = variances)
  structure(object, class = "summary_mplus")
}


#' @export
print.summary_mplus <- function(x, ...) {
  cat("modsem: \nMethod =", attributes(x)$method, "\n")
  printParTable(x$parTable,
                scientific = x$format$scientific,
                ci = x$format$ci,
                digits = x$format$digits,
                loadings = x$format$loadings,
                regressions = x$format$regressions,
                covariances = x$format$covariances,
                intercepts = x$format$intercepts,
                variances = x$format$variances)
}


#' @export
print.modsem_mplus <- function(x, ...) {
  cat("modsem: \nMethod =", attributes(x)$method, "\n")
  print(x$parTable)
}


#' @export
#' @describeIn parameter_estimates Get parameter estimates of a \code{\link{modsem_mplus}} object
parameter_estimates.modsem_mplus <- function(object, ...) {
  object$parTable
}


#' @export
var_interactions.modsem_mplus <- function(object, ...) {
  var_interactions.data.frame(parameter_estimates(object))
}


#' @export
standardized_estimates.modsem_mplus <- function(object, ...) {
  standardized_estimates.data.frame(parameter_estimates(object))
}


#' @export
#' @importFrom stats nobs
nobs.modsem_mplus <- function(object, ...) {
  NROW(object$data)
}
