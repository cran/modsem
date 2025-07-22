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
# tpb <- '
# # Outer Model (Based on Hagger et al., 2007)
#   ATT =~ att1 + att2 + att3 + att4 + att5
#   SN =~ sn1 + sn2
#   PBC =~ pbc1 + pbc2 + pbc3
#   INT =~ int1 + int2 + int3
#   BEH =~ b1 + b2
# 
# # Inner Model (Based on Steinmetz et al., 2011)
#   INT ~ ATT + SN + PBC
#   BEH ~ INT + PBC
#   BEH ~ INT:PBC
# 
# # Adding Latent Intercepts
#   INT ~ 1
#   BEH ~ 1
#   PBC ~ 1
#   SN  ~ 1
#   ATT ~ 1
# '
# 
# est <- modsem(tpb, TPB, method = "lms", nodes = 32)
# summary(est)

## -----------------------------------------------------------------------------
# summary(est, standardized = TRUE, centered = TRUE)

## -----------------------------------------------------------------------------
# centered_estimates(est)

