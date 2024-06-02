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
#  X =~ x1 + x2 + x3
#  Y =~ y1 + y2 + y3
#  Z =~ z1 + z2 + z3
#  
#  # Inner model
#  Y ~ X + Z + Z:X + X:X
#  '
#  
#  est1Lms <- modsem(m1, data = oneInt, method = "lms")
#  summary(est1Lms)

## -----------------------------------------------------------------------------
#  m2 <- '
#  ENJ =~ enjoy1 + enjoy2 + enjoy3 + enjoy4 + enjoy5
#  CAREER =~ career1 + career2 + career3 + career4
#  SC =~ academic1 + academic2 + academic3 + academic4 + academic5 + academic6
#  CAREER ~ ENJ + SC + ENJ:ENJ + SC:SC + ENJ:SC
#  '
#  
#  est2Dblcent <- modsem(m2, data = jordan)
#  est2Qml <- modsem(m2, data = jordan, method = "qml")
#  summary(est2Qml)

