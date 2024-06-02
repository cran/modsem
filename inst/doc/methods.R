## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----setup--------------------------------------------------------------------
#  library(modsem)

## ----eval = FALSE-------------------------------------------------------------
#  
#  m1 <- '
#  # Outer Model
#  X =~ x1 + x2 + x3
#  Y =~ y1 + y2 + y3
#  Z =~ z1 + z2 + z3
#  
#  # Inner model
#  Y ~ X + Z + X:Z
#  '
#  
#  modsem(m1, data = oneInt, method = "ca")
#  modsem(m1, data = oneInt, method = "uca")
#  modsem(m1, data = oneInt, method = "rca")
#  modsem(m1, data = oneInt, method = "dblcent")
#  modsem(m1, data = oneInt, method = "mplus")
#  modsem(m1, data = oneInt, method = "lms")
#  modsem(m1, data = oneInt, method = "qml")

