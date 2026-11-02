## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup--------------------------------------------------------------------
# library(modsem)

## -----------------------------------------------------------------------------
# tpb_uk <- "
# # Outer Model (Based on Hagger et al., 2007)
#   ATT =~ att1 + att2 + att3 + att4 + att5
#   SN =~ sn1 + sn2 + sn3
#   PBC =~ pbc1 + pbc2 + pbc3 + pbc4
#   INT =~ int1 + int2 + int3 + int4
#   BEH =~ beh1 + beh2 + beh3
# 
# # Inner Model (Based on Steinmetz et al., 2011)
#   INT ~ ATT + SN + PBC
#   BEH ~ INT + PBC
#   BEH ~ INT:PBC
# "
# 
# fit <- modsem(tpb_uk,
#               data = TPB_UK,
#               method = "lms",
#               nodes = 32, # Number of nodes for numerical integration
#               adaptive.quad = TRUE, # Use quasi-adaptive quadrature
#               adaptive.frequency = 3, # Update the quasi-adaptive quadrature every third EM-iteration
#               adaptive.quad.tol = 1e-12, # Relative error tolerance for quasi-adaptive quad
#               algorithm ="EMA", # Use accelerated EM algorithm (Default)
#               convergence.abs = 1e-4, # Absolute convergence criterion
#               convergence.rel = 1e-10, # Relative convergence criterion
#               convergence.grad = 1e-3, # Gradient convergence criterion
#               max.iter = 500, # Maximum number of iterations
#               max.step = 1) # Maximum number of steps in the maximization step
# summary(fit)

