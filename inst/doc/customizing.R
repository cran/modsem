## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup, eval = TRUE-------------------------------------------------------
library(modsem)

## -----------------------------------------------------------------------------
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

## ----eval = TRUE--------------------------------------------------------------
m3 <- '
# Outer Model
X =~ x1 + x2
Y =~ y1 + y2
Z =~ z1 + z2

# Inner model
Y ~ X + Z + X:Z 
'
syntax <- get_pi_syntax(m3)
cat(syntax)

## ----eval = TRUE--------------------------------------------------------------
data <- get_pi_data(m3, oneInt)
head(data)

