## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = TRUE
)

## ----setup--------------------------------------------------------------------
library(modsem)

## -----------------------------------------------------------------------------
m1 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ y1 + y2 + y3

# Inner Model
  Y ~ X + Z + X:Z
"
est1 <- modsem(m1, data = oneInt)
plot_interaction(x = "X", z = "Z", y = "Y",
                 vals_z = -3:3, model = est1)

## -----------------------------------------------------------------------------
tpb <- "
# Outer Model (Based on Hagger et al., 2007)
  ATT =~ att1 + att2 + att3 + att4 + att5
  SN =~ sn1 + sn2
  PBC =~ pbc1 + pbc2 + pbc3
  INT =~ int1 + int2 + int3
  BEH =~ b1 + b2

# Inner Model (Based on Steinmetz et al., 2011)
  INT ~ ATT + SN + PBC
  BEH ~ INT + PBC
  BEH ~ PBC:INT
"

est2 <- modsem(tpb, TPB, method = "lms")
plot_interaction(x = "INT", z = "PBC", y = "BEH",
                 vals_z = c(-0.5, 0.5), model = est2)

## -----------------------------------------------------------------------------
m1 <-  '
  visual  =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9

  visual ~ speed + textual + speed:textual
'

est1 <- modsem(m1, data = lavaan::HolzingerSwineford1939, method = "ca")
plot_jn(x = "speed", z = "textual", y = "visual", model = est1, max_z = 6)

## -----------------------------------------------------------------------------
tpb <- "
# Outer Model (Based on Hagger et al., 2007)
  ATT =~ att1 + att2 + att3 + att4 + att5
  SN =~ sn1 + sn2
  PBC =~ pbc1 + pbc2 + pbc3
  INT =~ int1 + int2 + int3
  BEH =~ b1 + b2

# Inner Model (Based on Steinmetz et al., 2011)
  INT ~ ATT + SN + PBC
  BEH ~ INT + PBC
  BEH ~ PBC:INT
"

est2 <- modsem(tpb, TPB, method = "qml")
plot_jn(x = "INT", z = "PBC", y = "BEH", model = est2,
        min_z = -1.5, max_z = -0.5)

## ----eval = EVAL_DEFAULT------------------------------------------------------
# tpb <- "
# # Outer Model (Based on Hagger et al., 2007)
#   ATT =~ att1 + att2 + att3 + att4 + att5
#   SN =~ sn1 + sn2
#   PBC =~ pbc1 + pbc2 + pbc3
#   INT =~ int1 + int2 + int3
#   BEH =~ b1 + b2
# 
# # Inner Model (Based on Steinmetz et al., 2011)
#   INT ~ ATT + SN + PBC
#   BEH ~ INT + PBC
#   BEH ~ PBC:INT
# "
# 
# est2 <- modsem(tpb, TPB, method = "qml")
# plot_surface(x = "INT", z = "PBC", y = "BEH", model = est2)

## -----------------------------------------------------------------------------
set.seed(2934269)

var_X      <- 1
var_Z      <- 1
cov_X_Z    <- 0.2

zeta_Y     <- 0.4

gamma_Y_X  <-  0
gamma_Y_Z  <-  0
gamma_Y_XZ <-  1
gamma_Y_ZZ <-  3 # exclude for now
gamma_Y_XX <- -1 # exclude for now


lambda_1   <- 1
lambda_2   <- .7
lambda_3   <- .8


epsilon    <- 0.2
beta_1     <- 1.2
beta_2     <- 0.8
beta_3     <- 1.5
N          <- 1500

residual <- \(epsilon) rnorm(N, sd = sqrt(epsilon))
create_ind <- \(lv, beta, lambda, epsilon) beta + lambda * lv + residual(epsilon)


Phi <- matrix(c(var_X, cov_X_Z,
                cov_X_Z, var_Z), nrow = 2)
XI <- mvtnorm::rmvnorm(N, sigma = Phi)

X <- XI[, 1]
Z <- XI[, 2]

Y <-
  gamma_Y_X * X +
  gamma_Y_Z * Z +
  gamma_Y_XZ * X * Z +
  gamma_Y_XX * X * X +
  gamma_Y_ZZ * Z * Z +
  residual(zeta_Y)

x1 <- create_ind(X, beta_1, lambda_1, epsilon)
x2 <- create_ind(X, beta_2, lambda_2, epsilon)
x3 <- create_ind(X, beta_3, lambda_2, epsilon)

z1 <- create_ind(Z, beta_1, lambda_1, epsilon)
z2 <- create_ind(Z, beta_2, lambda_2, epsilon)
z3 <- create_ind(Z, beta_3, lambda_2, epsilon)

y1 <- create_ind(Y, beta_1, lambda_1, epsilon)
y2 <- create_ind(Y, beta_2, lambda_2, epsilon)
y3 <- create_ind(Y, beta_2, lambda_2, epsilon)


data.sim <- data.frame(
   x1, x2, x3,
   z1, z2, z3,
   y1, y2, y3
)

## ----eval = EVAL_DEFAULT------------------------------------------------------
# model <- '
#   X =~ x1 + x2 + x3
#   Z =~ z1 + z2 + z3
#   Y =~ y1 + y2 + y3
# 
#   Y ~ X + Z + X:X + Z:Z + X:Z
# '
# 
# est3 <- modsem(model, data = data.sim, method = "qml")

## ----eval = EVAL_DEFAULT------------------------------------------------------
# plot_interaction(x = "X", z = "Z", y = "Y", model = est3, vals_z = c(-1, 0, 1))

## ----eval = EVAL_DEFAULT------------------------------------------------------
# plot_surface(x = "X", z = "Z", y = "Y", model = est3)

