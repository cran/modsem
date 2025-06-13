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
# m1 <- "
# # Outer Model
#   X =~ x1
#   X =~ x2 + x3
#   Z =~ z1 + z2 + z3
#   Y =~ y1 + y2 + y3
# 
# # Inner Model
#   Y ~ X + Z + X:Z
# "
# est1 <- modsem(m1, data = oneInt)
# plot_interaction(x = "X", z = "Z", y = "Y", vals_z = c(-1, 1), model = est1)

## -----------------------------------------------------------------------------
# m1 <- "
# # Outer Model
#   X =~ x1
#   X =~ x2 + x3
#   Z =~ z1 + z2 + z3
#   Y =~ y1 + y2 + y3
# 
# # Inner Model
#   Y ~ X + Z + X:Z
# "
# 
# est1 <- modsem(m1, data = oneInt)
# simple_slopes(x = "X", z = "Z", y = "Y", vals_z = c(-1, 1), model = est1)

## -----------------------------------------------------------------------------
# m1 <- "
# # Outer Model
#   X =~ x1
#   X =~ x2 + x3
#   Z =~ z1 + z2 + z3
#   Y =~ y1 + y2 + y3
# 
# # Inner Model
#   Y ~ X + Z + X:Z
# "
# 
# est1 <- modsem(m1, data = oneInt)
# slopes <- simple_slopes(x = "X", z = "Z", y = "Y",
#                         vals_z = c(0, 1), model = est1)
# as.data.frame(slopes)

