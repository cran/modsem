## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup--------------------------------------------------------------------
# library(modsem)

## -----------------------------------------------------------------------------
# set.seed(2834027) # set seed for reproducibility
# n.missing <- 200L # generate 200 missing values
# oneInt2 <- as.matrix(oneInt)
# oneInt2[sample(length(oneInt2), n.missing)] <- NA
# 
# m1 <- '
# # Outer Model
#   X =~ x1 + x2 + x3
#   Z =~ z1 + z2 + z3
#   Y =~ y1 + y2 + y3
# 
# # Inner Model
#   Y ~ X + Z + X:Z
# '
# 
# lms_fiml <- modsem(m1, oneInt2, method = "lms", missing = "fiml")
# summary(lms_fiml)

## -----------------------------------------------------------------------------
# qml_impute <- modsem(m1, oneInt2, method = "qml", missing = "impute")
# summary(qml_impute)

## -----------------------------------------------------------------------------
# lms_mimpute <- modsem_mimpute(m1, oneInt2, method = "lms")
# summary(lms_mimpute)

