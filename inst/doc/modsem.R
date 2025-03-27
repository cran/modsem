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
#  m1 <- '
#    # Outer Model
#    X =~ x1 + x2 + x3
#    Y =~ y1 + y2 + y3
#    Z =~ z1 + z2 + z3
#  
#    # Inner Model
#    Y ~ X + Z + X:Z
#  '
#  
#  est1 <- modsem(m1, oneInt)
#  summary(est1)

## -----------------------------------------------------------------------------
#  est1 <- modsem(m1, oneInt, method = "lms")
#  summary(est1)

## -----------------------------------------------------------------------------
#  reg1 <- lm(y1 ~ x1*z1, oneInt)
#  summary(reg1)

## -----------------------------------------------------------------------------
#  # Using "pind" as the method (see Chapter 3)
#  est2 <- modsem('y1 ~ x1 + z1 + x1:z1', data = oneInt, method = "pind")
#  summary(est2)

## -----------------------------------------------------------------------------
#  m3 <- '
#    # Outer Model
#    X =~ x1 + x2 + x3
#    Y =~ y1 + y2 + y3
#  
#    # Inner Model
#    Y ~ X + z1 + X:z1
#  '
#  
#  est3 <- modsem(m3, oneInt, method = "pind")
#  summary(est3)

## -----------------------------------------------------------------------------
#  m4 <- '
#  # Outer Model
#  X =~ x1 + x2 + x3
#  Y =~ y1 + y2 + y3
#  Z =~ z1 + z2 + z3
#  
#  # Inner Model
#  Y ~ X + Z + Z:X + X:X
#  '
#  
#  est4 <- modsem(m4, oneInt, method = "qml")
#  summary(est4)

## -----------------------------------------------------------------------------
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
#    BEH ~ INT + PBC + INT:PBC
#  '
#  
#  # The double-centering approach
#  est_tpb <- modsem(tpb, TPB)
#  
#  # Using the LMS approach
#  est_tpb_lms <- modsem(tpb, TPB, method = "lms")
#  summary(est_tpb_lms)

## -----------------------------------------------------------------------------
#  m2 <- '
#  ENJ =~ enjoy1 + enjoy2 + enjoy3 + enjoy4 + enjoy5
#  CAREER =~ career1 + career2 + career3 + career4
#  SC =~ academic1 + academic2 + academic3 + academic4 + academic5 + academic6
#  CAREER ~ ENJ + SC + ENJ:ENJ + SC:SC + ENJ:SC
#  '
#  
#  est_jordan <- modsem(m2, data = jordan)
#  est_jordan_qml <- modsem(m2, data = jordan, method = "qml")
#  summary(est_jordan_qml)

