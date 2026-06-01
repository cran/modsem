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
#   # Latent Variables
#   SN =~ sn1 + sn2
#   PBC =~ pbc1 + pbc2 + pbc3
#   INT =~ int1 + int2 + int3
# 
#   # Composites
#   ATT <~ att1 + att2 + att3 + att4 + att5
#   BEH <~ b1 + b2
# 
# # Inner Model (Based on Steinmetz et al., 2011)
#   INT ~ ATT + SN + PBC
#   BEH ~ INT + PBC + INT:PBC
# '
# 
# fit <- modsem(tpb, TPB, method = "lms", nodes = 32)
# summary(fit)

