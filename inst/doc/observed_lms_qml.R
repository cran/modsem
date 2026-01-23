## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- TRUE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup--------------------------------------------------------------------
library(modsem)

## -----------------------------------------------------------------------------
library(modsem)

fit <- modsem('y1 ~ x1 + z1 + x1:z1', data = oneInt, method = "lms")
summary(fit, standardized = TRUE)

## -----------------------------------------------------------------------------
# Interaction effect between a latent and an observed variable
m1 <- '
# Outer Model
  X =~ x1 # X is observed
  Z =~ z1 + z2 # Z is latent
  Y =~ y1 # Y is observed

# Inner model
  Y ~ X + Z
  Y ~ Z:X
'

lms1 <- modsem(m1, oneInt, method = "lms")

# Interaction effect between two observed variables
m2 <- '
# Outer Model
  X =~ x1 # X is observed
  Z =~ z1 # Z is observed
  Y =~ y1 # Y is observed
  x1 ~~ 0.1 * x1 # Specify a variance for the measurement error

# Inner model
  Y ~ X + Z
  Y ~ X:Z
'

lms2 <- modsem(m2, oneInt, method = "lms")
summary(lms2)

## ----error = TRUE-------------------------------------------------------------
try({
m2 <- '
# Outer Model
  X =~ x1 # X is observed
  Z =~ z1 # Z is observed
  Y =~ y1 # Y is observed

# Inner model
  Y ~ X + Z
  Y ~ X:Z
'

lms3 <- modsem(m2, oneInt, method = "lms")
})

## -----------------------------------------------------------------------------
m3 <- '
# Outer Model
  X =~ x1 # X is observed
  Z =~ z1 # Z is observed
  Y =~ y1 # Y is observed

# Inner model
  Y ~ X + Z
  Y ~ X:Z
'

qml3 <- modsem(m3, oneInt, method = "qml")
summary(qml3)

