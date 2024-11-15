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
# library(modsem)
# m1 <- '
# # Outer Model
#   X =~ x1
#   X =~ x2 + x3
#   Z =~ z1 + z2 + z3
#   Y =~ y1 + y2 + y3
# 
# # Inner Model
#   Y ~ X + Z
#   Y ~ X:Z
# '
# 
# lms1 <- modsem(m1, oneInt, method = "lms")
# summary(lms1, standardized = TRUE) # Standardized estimates

## -----------------------------------------------------------------------------
# qml1 <- modsem(m1, oneInt, method = "qml")
# summary(qml1)

## -----------------------------------------------------------------------------
# # ATT = Attitude
# # PBC = Perceived Behavioral Control
# # INT = Intention
# # SN = Subjective Norms
# # BEH = Behavior
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
# '
# 
# lms2 <- modsem(tpb, TPB, method = "lms", nodes = 32)
# summary(lms2)
# 
# qml2 <- modsem(tpb, TPB, method = "qml")
# summary(qml2, standardized = TRUE) # Standardized estimates

