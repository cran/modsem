## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----setup--------------------------------------------------------------------
#  library(modsem)

## -----------------------------------------------------------------------------
#  library(modsem)
#  m1 <- '
#  # Outer Model
#    X =~ x1
#    X =~ x2 + x3
#    Z =~ z1 + z2 + z3
#    Y =~ y1 + y2 + y3
#  
#  # Inner model
#    Y ~ X + Z
#    Y ~ X:Z
#  '
#  
#  lms1 <- modsem(m1, oneInt, method = "lms")
#  summary(lms1)

## -----------------------------------------------------------------------------
#  qml1 <- modsem(m1, oneInt, method = "qml")
#  summary(qml1)

## -----------------------------------------------------------------------------
#  # ATT = Attitude,
#  # PBC = Perceived Behavioural Control
#  # INT = Intention
#  # SN = Subjective Norms
#  # BEH = Behaviour
#  tpb <- '
#  # Outer Model (Based on Hagger et al., 2007)
#    ATT =~ att1 + att2 + att3 + att4 + att5
#    SN =~ sn1 + sn2
#    PBC =~ pbc1 + pbc2 + pbc3
#    INT =~ int1 + int2 + int3
#    BEH =~ b1 + b2
#  
#  # Inner Model (Based on Steinmetz et al., 2011)
#    INT ~ ATT + SN + PBC
#    BEH ~ INT + PBC
#    BEH ~ INT:PBC
#  '
#  
#  lms2 <- modsem(tpb, TPB, method = "lms", nodes = 20)
#  summary(lms2)

