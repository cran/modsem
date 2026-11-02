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
#  ATT =~ att1 + att2 + att3 + att4 + att5
#  SN =~ sn1 + sn2 + sn3
#  PBC =~ pbc1 + pbc2 + pbc3 + pbc4
#  INT =~ int1 + int2 + int3 + int4
#  BEH =~ beh1 + beh2 + beh3
# 
# # Inner Model (Based on Steinmetz et al., 2011)
#  INT ~ ATT + SN + PBC
#  BEH ~ INT + PBC
#  BEH ~ INT:PBC
# "
# 
# corrected <- relcorr_single_item(syntax = tpb_uk, data = TPB_UK)
# corrected

## -----------------------------------------------------------------------------
# syntax <- corrected$syntax
# data   <- corrected$data
# 
# est_dca <- modsem(syntax, data = data, method = "dblcent")
# est_lms <- modsem(syntax, data = data, method="lms", nodes=32)
# summary(est_lms)

## -----------------------------------------------------------------------------
# est_dca <- modsem(tpb_uk, data = TPB_UK, method = "dblcent", rcs = TRUE)
# est_lms <- modsem(tpb_uk, data = TPB_UK, method = "lms", rcs = TRUE)

## -----------------------------------------------------------------------------
# relcorr_single_item(syntax = tpb_uk, data = TPB_UK,
#                     choose = c("ATT", "SN", "PBC", "INT"))
# 
# est_dca <- modsem(tpb_uk, data = TPB_UK, method = "dblcent", rcs = TRUE,
#                   rcs.choose = c("ATT", "SN", "PBC", "INT", "INT:PBC"))
# summary(est_dca)

