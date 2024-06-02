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
#  Y ~ X + Z + X:Z
#  '
#  
#  est1 <- modsem(m1, oneInt)
#  cat(est1$syntax)

## -----------------------------------------------------------------------------
#  m2 <- '
#  # Outer Model
#  X =~ x1 + x2
#  Y =~ y1 + y2
#  Z =~ z1 + z2
#  
#  # Inner model
#  Y ~ X + Z + X:Z
#  '
#  
#  est2 <- modsem(m2, oneInt, match = TRUE)
#  summary(est2)

## -----------------------------------------------------------------------------
#  m3 <- '
#  # Outer Model
#  X =~ x1 + x2
#  Y =~ y1 + y2
#  Z =~ z1 + z2
#  
#  # Inner model
#  Y ~ X + Z + X:Z
#  '
#  est3 <- modsem(m3, oneInt, run = FALSE)
#  cat(est3$syntax)

## -----------------------------------------------------------------------------
#  head(est3$data)

