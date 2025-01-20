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
  X =~ x1
  X =~ x2 + x3
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

