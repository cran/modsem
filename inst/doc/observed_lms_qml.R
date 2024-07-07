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
#  
#  # interaction effect between a latent and an observed variable
#  m1 <- '
#  # Outer Model
#    X =~ x1 # X is observed
#    Z =~ z1 + z2 # Z is latent
#    Y =~ y1 # Y is observed
#  
#  # Inner model
#    Y ~ X + Z
#    Y ~ Z:X
#  '
#  
#  lms1 <- modsem(m1, oneInt, method = "lms")
#  
#  # interaction effect between two observed variables
#  m2 <- '
#  # Outer Model
#    X =~ x1 # X is observed
#    Z =~ z1 # Z is observed
#    Y =~ y1 # Y is observed
#    x1 ~~ 0.1 * x1 # specify a variance for the measurement error
#  # Inner model
#    Y ~ X + Z
#    Y ~ X:Z
#  '
#  
#  lms2 <- modsem(m1, oneInt, method = "lms")

## -----------------------------------------------------------------------------
#  m3 <- '
#  # Outer Model
#    X =~ x1 # X is observed
#    Z =~ z1 # Z is observed
#    Y =~ y1 + y2 # Y needs to be latent, needing atleast two indicators
#  
#  # Inner model
#    Y ~ X + Z
#    Y ~ X:Z
#  '
#  
#  qml3 <- modsem(m3, oneInt, method = "qml")

