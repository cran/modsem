preCheckModel <- function(model, covModel = NULL, method = "lms") {
  hasCovModel <- !is.null(model$covModel$matrices)

  checkCovModelVariables(covModel = covModel, modelXis = model$info$xis)

  checkZeroVariances(model = model, method = method)

  checkNodesLms(parTableMain = model$parTable,
                parTableCov  = covModel$parTable,
                nodes = model$quad$m, method = method,
                adaptive = model$quad$adaptive)

  checkOVsInStructuralModel(parTableMain = model$parTable,
                            parTableCov  = covModel$parTable)

  checkOverlappingIndicators(allIndsXis = model$info$allIndsXis,
                             allIndsEtas = model$info$allIndsEtas)

  checkAConstraints(model = model, covModel = covModel, method = method)

  checkCovEtaXi(parTable = model$parTable, canBeCausedByCovModel = hasCovModel)
  checkCovEtaXi(parTable = model$covModel$parTable, canBeCausedByCovModel = FALSE)

  checkOmegaEtaXi(model = model, method = method)
}


checkAConstraints <- function(model, covModel, method = "lms") {
  if (method != "lms" || !is.null(covModel$matrices)) return(NULL)

  An <- model$matrices$A
  Al <- model$labelMatrices$A

  isOKALabel <- all(Al == "")
  isOKANumeric <- all(is.na(An[lower.tri(An, diag = TRUE)])) || 
                 !any(is.na(An[lower.tri(An)]))

  warnif(!isOKALabel || !isOKANumeric,
         "Variances and covariances of exogenous variables aren't truely ",
         "free parameters in the LMS approach. Using them in model constraints ",
         "affecting the model estimation will likely not work as expected!\n\n",
         "If the label is unused, or only used to compute custom parameters (using `:=`) ",
         "which don't affect the model estimation, you can ignore this warning.\n\n",
         'To fix this you can pass an empty model to `cov.syntax`, for example: \n',
         '    `modsem(my_model, data = my_data, method = "lms", cov.syntax = "")`\n'
  )
}


checkCovModelVariables <- function(covModel, modelXis, method = "lms") {
  if (is.null(covModel$matrices)) return(NULL) # nothing to check
  covModelEtas <- covModel$info$etas
  covModelXis  <- covModel$info$xis

  stopif(!all(c(covModelXis, covModelEtas) %in% modelXis),
         "All latent variables in the cov-model must be an ",
         "exogenous variable in the main model")
  stopif(!all(modelXis %in% c(covModelXis, covModelEtas)),
         "All exogenous variables in main model must be ",
         "part of the cov-model")
}


checkZeroVariances <- function(model, method = "lms") {
  if (method != "lms") return(NULL)
  
  nonLinearXis <- model$info$nonLinearXis
  inds <- model$info$indsXis[nonLinearXis]

  thetaDelta <- model$matrices$thetaDelta 

  message <- paste(
      "The variance of a moderating variable of integration",
      "has an indicator with zero residual variance!",
      "\nThis will likely not work with the LMS approach, see:",
      "\n   `vignette('observed_lms_qml', 'modsem')` for more information.",
      "\n\nThe following indicators have zero residual variance:"
  )

  m1 <- \(i) sprintf("  -> %s", i)

  width <- options()$width
  width <- if (is.null(width) || width == Inf) 30 else (width - 11) / 2

  error <- FALSE
  for (lv in nonLinearXis) for (ind in inds[[lv]]) {
    est <- thetaDelta[ind, ind]

    if (!is.na(est) && est == 0) {
      error <- TRUE
      message <- paste(message, m1(ind), sep = "\n")
    }
  }

  if (error) stop2(message)
}


checkNodesLms <- function(parTableMain,
                          parTableCov,
                          nodes,
                          method = "lms",
                          adaptive = FALSE,
                          minNodesXiXi   = if (!adaptive) 16 else 15,
                          minNodesXiEta  = if (!adaptive) 32 else 32,
                          minNodesEtaEta = if (!adaptive) 48 else 32) {
  if (method != "lms") return(NULL)

  parTable <- rbind(parTableMain, parTableCov)

  etas     <- getEtas(parTable, isLV = TRUE)
  xis      <- getXis(parTable, etas = etas, isLV = TRUE)
  varsInts <- getVarsInts(getIntTermRows(parTable))

  nodesXiXi_ok   <- TRUE
  nodesXiEta_ok  <- TRUE
  nodesEtaEta_ok <- TRUE

  lapply(varsInts, FUN = function(x) {
    if      (all(x %in% xis))  nodesXiXi_ok   <<- nodes >= minNodesXiXi
    else if (all(x %in% etas)) nodesEtaEta_ok <<- nodes >= minNodesEtaEta
    else if (any(x %in% etas)) nodesXiEta_ok  <<- nodes >= minNodesXiEta
    else warning2("Unable to classify latent variables in interaction terms")
  })

  warnif(!nodesXiXi_ok, "It is recommended that you have at least ",
         minNodesXiXi,  " nodes for interaction effects between ",
         "exogenous variables in the lms approach 'nodes = ", nodes, "'")
  warnif(!nodesXiEta_ok, "It is recommended that you have at least ",
         minNodesXiEta, " nodes for interaction effects between exogenous ",
         "and endogenous variables in the lms approach 'nodes = ", nodes, "'")
  warnif(!nodesEtaEta_ok, "It is recommended that you have at least ",
         minNodesEtaEta, " nodes for interaction effects between endogenous ",
         "variables in the lms approach 'nodes = ", nodes, "'")
}


checkCovEtaXi <- function(parTable, canBeCausedByCovModel = FALSE) {
  if (!NROW(parTable)) 
    return(NULL)

  etas <- getEtas(parTable, checkAny = FALSE, isLV = FALSE)
  xis  <- getXis(parTable, checkAny = FALSE, isLV = FALSE, etas = etas)

  isCov <- parTable$op == "~~"
  lxi   <- parTable$lhs %in% xis
  rxi   <- parTable$rhs %in% xis
  leta  <- parTable$lhs %in% etas
  reta  <- parTable$rhs %in% etas

  problematicRows <- isCov & ((lxi & reta) | (leta & rxi))

  if (canBeCausedByCovModel) {
    msgcov <- paste0(
      "\nThis may be because the model has been split into linear and non-linear parts!\n",
      "You can try passing `auto.split.syntax=FALSE` and `cov.syntax=NULL`..."
    ) 
  } else msgcov <- ""

  msg <- paste0(
    "Covariances between exogenous and endogenous variables are not available,\n",
    "and will be ignored! The problematic covariances are:\n",
    capturePrint(parTable[problematicRows, ]),
    msgcov
  )

  warnif(any(problematicRows), msg, immediate. = TRUE)
}


checkOmegaEtaXi <- function(model, method = "qml", zero.tol = 1e-10) {
  if (method != "qml") return(NULL)

  omegaEtaXi <- model$matrices$omegaEtaXi
  problematic <- any(is.na(omegaEtaXi) | abs(omegaEtaXi) > zero.tol)

  warnif(problematic, 
         "Interactions between exogenous and enodgenous variables in the QML\n",
         "approach can be biased in some cases...\n",
         "You can try passing `auto.split.syntax=FALSE` and `cov.syntax=NULL`...")
}


checkOVsInStructuralModel <- function(parTableMain, parTableCov) {
  parTable <- rbind(parTableMain, parTableCov)
  xisLVs   <- getXis(parTable, isLV = TRUE)
  xisAll   <- getXis(parTable, isLV = FALSE)

  stopif(length(xisAll) != length(xisLVs) || !all(xisLVs %in% xisAll),
         "Observed variables are not allowed in the structural model in LMS/QML directly. ",
         "Please redefine them as latent.\nSee:\n",
         "  vignette(\"observed_lms_qml\", \"modsem\")")
}


checkOverlappingIndicators <- function(allIndsXis, allIndsEtas) {
  stopif(any(allIndsXis %in% allIndsEtas),
         "The same indicator cannot be used for both an exogenous ",
         "and endogenous variable, in the same model: ",
         paste(allIndsXis[allIndsXis %in% allIndsEtas], collapse = ", "))
}


checkParTableDA <- function(parTable) {
  stopif(length(getHigherOrderLVs(parTable)) > 0,
         "Higher-order latent variables are not supported in the lms and qml approaches.")
}


checkVarsIntsDA <- function(varsInts, lVs) {
  for (xz in varsInts) {
    stopif(!all(xz %in% lVs), "Element in product term is not a latent variable: `",
           xz[!xz %in% lVs][[1]], "`!\n",
           "If it is an observed variable, please redefine it as a latent variable.\n",
           "See:\n  vignette(\"observed_lms_qml\", \"modsem\")")
  }
}


postCheckModel <- function(model) {
  parTable <- model$parTable

  checkParTableEstimates(parTable)
  checkVariances(model$expected.matrices)
  checkVCOV(vcov(model, type = "free"), calc.se = model$args$calc.se)
}


checkParTableEstimates <- function(parTable) {
  estimates <- parTable$est

  anyNonFinite <- any(is.na(estimates) | is.nan(estimates) | is.infinite(estimates))
  warnif(anyNonFinite, "Some parameters could not be computed (NA, NaN or Inf)!",
         immediate. = FALSE)
}


checkVariances <- function(expected.matrices, rel.diff.tol = 1000) {
  variances.lv <- diag(expected.matrices$sigma.lv)
  variances.ov <- diag(expected.matrices$sigma.ov)

  check <- function(variances, type) {
    minVar <- min(variances, na.rm = TRUE) # should never be any NA, but just in case...
    maxVar <- max(variances, na.rm = TRUE) 
    relDiff <- maxVar / minVar

    anyNeg <- any(variances < 0)
    warnif(anyNeg, "Some estimated %s variances are negative!", immediate. = FALSE)
    
    warnif(
      relDiff > rel.diff.tol,
      sprintf("Some estimated %s variances are (at least) a factor %i times larger than others", 
              type, rel.diff.tol),
      immediate. = FALSE
    )
  }

  check(variances.lv, type = "lv")
  check(variances.ov, type = "ov")
}


checkVCOV <- function(vcov, calc.se = TRUE, tol.eigen = .Machine$double.eps ^ (3/4)) {
  if (!calc.se) return(NULL) # checks not relevant

  eigenvalues <- eigen(vcov, only.values = TRUE)$values 

  if (all(is.na(eigenvalues))) {
    warning2("Unable to compute eigenvalues of the variance-covariance matrix!")
    return(NULL)
  }

  minval <- min(eigenvalues, na.rm = TRUE) # should never be any NA, but just in case...
  if (minval < tol.eigen) {
    warnif(minval >= 0, 
           "The variance-covariance matrix of the estimated\n",
           "parameters (vcov) does not appear to be positive\n",
           sprintf("definite! The smallest eigenvalue (= %e) is close\n", minval),
           "to zero. This may be a symptom that the model is\n",
           "not identified.", immediate. = FALSE)
    warnif(minval < 0,
           "The variance-covariance matrix of the estimated parameters\n",
           "(vcov) does not appear to be positive definite! The smallest\n",
           sprintf("eigenvalue (= %e) is smaller than zero. This may\n", minval),
           "be a symptom that the model is not identified.", immediate. = FALSE)
  }
}
