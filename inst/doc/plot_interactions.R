## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
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

# Inner model
  Y ~ X + Z + X:Z
"
est1 <- modsem(m1, data = oneInt)
plot_interaction("X", "Z", "Y", "X:Z", -3:3, c(-0.2, 0), est1)


## -----------------------------------------------------------------------------
tpb <- "
# Outer Model (Based on Hagger et al., 2007)
  ATT =~ att1 + att2 + att3 + att4 + att5
  LSN =~ sn1 + sn2
  PBC =~ pbc1 + pbc2 + pbc3
  INT =~ int1 + int2 + int3
  BEH =~ b1 + b2

# Inner Model (Based on Steinmetz et al., 2011)
  # Causal Relationsships
  INT ~ ATT + LSN + PBC
  BEH ~ INT + PBC
  # BEH ~ ATT:PBC
  BEH ~ PBC:INT
  # BEH ~ PBC:PBC
"

est2 <- modsem(tpb, TPB, method = "lms")
plot_interaction(x = "INT", z = "PBC", y = "BEH", xz = "PBC:INT", 
                 vals_z = c(-0.5, 0.5), model = est2)

