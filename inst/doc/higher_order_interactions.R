## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = EVAL_DEFAULT
)

## ----setup--------------------------------------------------------------------
#  library(modsem)

## -----------------------------------------------------------------------------
#  tpb <- '
#    # First order constructs
#    ATT =~ att1 + att2 + att3
#    SN  =~ sn1 + sn2 + sn3
#    PB =~ pb1 + pb2 + pb3
#    PC =~ pc1 + pc2 + pc3
#    BEH =~ b1 + b2
#  
#    # Higher order constructs
#    INT =~ ATT + SN
#    PBC =~ PC + PB
#  
#    # Higher order interaction
#    INTxPBC =~ ATT:PC + ATT:PB + SN:PC + SN:PB
#  
#    # Structural model
#    BEH ~ PBC + INT + INTxPBC
#  '
#  
#  est_ca <- modsem(tpb, data = TPB_2SO, method = "ca")
#  summary(est_ca)
#  
#  est_dblcent <- modsem(tpb, data = TPB_2SO, method = "dblcent")
#  summary(est_dblcent)

## -----------------------------------------------------------------------------
#  tpb <- '
#    # First order constructs
#    ATT =~ att1 + att2 + att3
#    SN  =~ sn1 + sn2 + sn3
#    PBC =~ pbc1 + pbc2 + pbc3
#    BEH =~ b1 + b2
#  
#    # Higher order constructs
#    INT =~ ATT + PBC + SN
#  
#    # Higher order interaction
#    INTxPBC =~ ATT:PBC + SN:PBC + PBC:PBC
#  
#    # Structural model
#    BEH ~ PBC + INT + INTxPBC
#  '
#  
#  est_ca <- modsem(tpb, data = TPB_1SO, method = "ca")
#  summary(est_ca)
#  
#  est_dblcent  <- modsem(tpb, data = TPB_1SO, method = "dblcent")
#  summary(est_dblcent)

