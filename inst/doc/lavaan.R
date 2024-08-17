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
#  library(lavaan)
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
#  est <- modsem(m1, oneInt)
#  lav_object <- extract_lavaan(est)
#  bootstrap <- bootstrapLavaan(lav_object, R = 500)

