## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup--------------------------------------------------------------------
#  library(modsem)

## -----------------------------------------------------------------------------
#  tpb_uk <- "
#  # Outer Model (Based on Hagger et al., 2007)
#    ATT =~ att3 + att2 + att1 + att4
#    SN =~ sn4 + sn2 + sn3 + sn1
#    PBC =~ pbc2 + pbc1 + pbc3 + pbc4
#    INT =~ int2 + int1 + int3 + int4
#    BEH =~ beh3 + beh2 + beh1 + beh4
#  
#  # Inner Model (Based on Steinmetz et al., 2011)
#    INT ~ ATT + SN + PBC
#    BEH ~ INT + PBC
#    BEH ~ INT:PBC
#  "
#  
#  fit <- modsem(tpb_uk,
#                data = TPB_UK,
#                method = "lms",
#                nodes = 32, # Number of nodes for numerical integration
#                adaptive.quad = TRUE, # Use quasi-adaptive quadrature
#                adaptive.frequency = 3, # Update the quasi-adaptive quadrature every third EM-iteration
#                algorithm ="EMA", # Use accelerated EM algorithm (Default)
#                convergence.abs = 1e-4, # Relative convergence criterion
#                convergence.rel = 1e-10, # Relative convergence criterion
#                max.iter = 500, # Maximum number of iterations
#                max.step = 1) # Maximum number of steps in the maximization step
#  summary(fit)

