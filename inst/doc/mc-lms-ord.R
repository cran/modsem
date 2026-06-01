## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup--------------------------------------------------------------------
# library(modsem)
# set.seed(2938472)

## -----------------------------------------------------------------------------
# ordinalize <- function(x, probs = c(0, 0.35, 0.7, 1)) {
#   x <- (x - mean(x)) / sd(x)
#   cut(
#     x,
#     breaks = stats::quantile(x, probs = probs),
#     include.lowest = TRUE,
#     ordered_result = TRUE
#   )
# }
# 
# oneIntOrd <- as.data.frame(lapply(oneInt, ordinalize))

## -----------------------------------------------------------------------------
# model <- "
#   X =~ x1 + x2 + x3
#   Z =~ z1 + z2 + z3
#   Y =~ y1 + y2 + y3
# 
#   Y ~ X + Z + X:Z
# "
# 
# fit_lms_ord <- modsem(
#   model,
#   data = oneIntOrd,
#   method = "lms",
#   ordered = colnames(oneIntOrd)
# )
# 
# summary(fit_lms_ord)

