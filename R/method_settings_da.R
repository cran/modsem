getMethodSettingsDA <- function(method, args = NULL) {
    settings <- list(
        lms = list(verbose = interactive(),
                   optimize = TRUE,
                   nodes = 24,
                   convergence.abs = 1e-4,
                   convergence.rel = 1e-10,
                   optimizer = "nlminb",
                   center.data = FALSE,
                   standardize.data = FALSE,
                   standardize.out = FALSE,
                   standardize = FALSE,
                   mean.observed = TRUE,
                   double = FALSE,
                   calc.se = TRUE,
                   FIM = "observed",
                   OFIM.hessian = TRUE,
                   EFIM.S = 100,
                   EFIM.parametric = TRUE,
                   robust.se = FALSE,
                   R.max = 1e5,
                   max.iter = 500,
                   max.step = 1,
                   epsilon = 1e-4,
                   quad.range = Inf,
                   adaptive.quad = TRUE,
                   adaptive.quad.tol = 1e-12,
                   adaptive.frequency = 3,
                   n.threads = NULL,
                   algorithm = "EMA",
                   em.control = list(),
                   impute.na = FALSE,
                   orthogonal.x = FALSE,
                   orthogonal.y = FALSE,
                   auto.fix.first = TRUE,
                   auto.fix.single = TRUE,
                   auto.split.syntax = FALSE
        ),
        qml = list(verbose = interactive(),
                   optimize = TRUE,
                   nodes = 0,
                   convergence.rel = 1e-6,
                   convergence.abs = NULL, # not relevant
                   optimizer = "nlminb",
                   center.data = FALSE,
                   standardize = FALSE,
                   standardize.data = FALSE,
                   standardize.out = FALSE,
                   mean.observed = TRUE,
                   double = FALSE,
                   calc.se = TRUE,
                   FIM = "observed",
                   OFIM.hessian = TRUE,
                   EFIM.S = 100,
                   EFIM.parametric = TRUE,
                   robust.se = FALSE,
                   R.max = 1e5,
                   max.iter = 500,
                   max.step = NULL,
                   epsilon = 1e-8,
                   quad.range = Inf,
                   adaptive.quad = FALSE,
                   adaptive.quad.tol = NULL,
                   n.threads = NULL,
                   adaptive.quad = FALSE,
                   adaptive.frequency = NULL,
                   em.control = NULL,
                   algorithm = NULL,
                   impute.na = FALSE,
                   orthogonal.x = FALSE,
                   orthogonal.y = FALSE,
                   auto.fix.first = TRUE,
                   auto.fix.single = TRUE,
                   auto.split.syntax = TRUE
        )
    )

    if (is.null(args)) return(settings[method])

    settingNames <- unique(unlist(lapply(settings, FUN = names)))
    args <- args[settingNames]
    isMissing <- vapply(args, FUN.VALUE = logical(1L), FUN = is.null)
    missingArgs <- settingNames[isMissing]

    stopif(!method %in% names(settings), "Unrecognized method")

    args.out <- c(settings[[method]][missingArgs], args[!isMissing])

    args.out$standardize.data <-
      args.out$standardize || args.out$standardize.data
    args.out$standardize.out <-
      args.out$standardize || args.out$standardize.out
    args.out$mean.observed <-
      !args.out$standardize && args.out$mean.observed
    args.out$OFIM.hessian <-
      args.out$OFIM.hessian && !args.out$robust.se
    args.out$center.data <- !args.out$standardize.data &&
      !args.out$mean.observed

    args.out$n.threads <- setThreads(args.out$n.threads)
    args.out
}



#' default arguments fro LMS and QML approach
#'
#' @param method which method to get the settings for
#' @return list
#' @export
#' @description
#' This function returns the default settings for the LMS and QML approach.
#' @examples
#' library(modsem)
#' default_settings_da()
default_settings_da <- function(method = c("lms", "qml")) {
  getMethodSettingsDA(method = method, args = NULL)
}
