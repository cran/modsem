## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----setup--------------------------------------------------------------------
#  library(modsem)

## -----------------------------------------------------------------------------
#  library(lavaan)
#  
#  m1 <- "
#  # Outer Model
#  X =~ x1 + x2 + x3
#  Y =~ y1 + y2 + y3
#  Z =~ z1 + z2 + z3
#  
#  # Inner model
#  Y ~ X + Z + X:Z
#  "
#  
#  est1 <- modsem(m1, oneInt)
#  lavObject <- est1$lavaan
#  bootstrap <- bootstrapLavaan(lavObject, R = 500)

