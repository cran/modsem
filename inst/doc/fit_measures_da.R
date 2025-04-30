## ----include=FALSE------------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup--------------------------------------------------------------------
#  library(modsem)

## -----------------------------------------------------------------------------
#  m1 <- "
#  # Outer (measurement) model
#  X =~ x1 + x2 + x3
#  Y =~ y1 + y2 + y3
#  Z =~ z1 + z2 + z3
#  
#  # Inner (structural) model
#  Y ~ X + Z + X:Z
#  "
#  
#  # Estimate the full (H1) model via LMS
#  est_h1 <- modsem(m1, oneInt, method = "lms")
#  
#  # Estimate the baseline (H0) model without interaction
#  est_h0 <- estimate_h0(est_h1, calc.se = FALSE) # std.errors are not needed

## -----------------------------------------------------------------------------
#  fit_modsem_da(est_h0)

## -----------------------------------------------------------------------------
#  fit_modsem_da(est_h1, chisq = FALSE)

## -----------------------------------------------------------------------------
#  compare_fit(est_h0, est_h1)

## -----------------------------------------------------------------------------
#  modsem_inspect(est_h1, what = "fit")

