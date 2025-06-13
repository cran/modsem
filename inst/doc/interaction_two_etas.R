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
#   BEH ~ INT:INT
# '

## -----------------------------------------------------------------------------
# tpb_linear <- 'INT ~ PBC + ATT + SN'

## -----------------------------------------------------------------------------
# tpb_nonlinear <- '
# # Outer Model (Based on Hagger et al., 2007)
#   ATT =~ att1 + att2 + att3 + att4 + att5
#   SN =~ sn1 + sn2
#   PBC =~ pbc1 + pbc2 + pbc3
#   INT =~ int1 + int2 + int3
#   BEH =~ b1 + b2
# 
# # Inner Model (Based on Steinmetz et al., 2011)
#   BEH ~ INT + PBC
#   BEH ~ INT:INT
# '

## -----------------------------------------------------------------------------
# est_lms <- modsem(tpb_nonlinear, data = TPB, cov.syntax = tpb_linear,
#                   method = "lms")
# summary(est_lms)
# 
# est_qml <- modsem(tpb_nonlinear, data = TPB, cov.syntax = tpb_linear,
#                   method = "qml")
# summary(est_qml)

