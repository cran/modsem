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
# tpb_2so <- '
#   # First order latent variables
#   ATT =~ att1 + att2 + att3
#   SN  =~ sn1 + sn2 + sn3
#   PB =~ pb1 + pb2 + pb3
#   PC =~ pc1 + pc2 + pc3
#   BEH =~ b1 + b2
# 
#   # Higher order latent variables
#   INT =~ ATT + SN
#   PBC =~ PC + PB
# 
#   # Structural model
#   BEH ~ PBC + INT + INT:PBC
# '
# 
# est_lms_2so <- modsem(tpb_2so, data = TPB_2SO, method = "lms")
# summary(est_lms_2so)

## -----------------------------------------------------------------------------
# tpb_1so <- '
#   # First order latent variables
#   ATT =~ att1 + att2 + att3
#   SN  =~ sn1 + sn2 + sn3
#   PBC =~ pbc1 + pbc2 + pbc3
#   BEH =~ b1 + b2
# 
#   # Higher order latent variables
#   INT =~ ATT + PBC + SN
# 
#   # Structural model
#   BEH ~ PBC + INT + INT:PBC
# '
# 
# est_lms_1so <- modsem(tpb_1so, data = TPB_1SO, method = "lms", nodes = 32)
# summary(est_lms_1so)

## -----------------------------------------------------------------------------
# tpb_2so <- '
#   # First order latent variables
#   ATT =~ att1 + att2 + att3
#   SN  =~ sn1 + sn2 + sn3
#   PB =~ pb1 + pb2 + pb3
#   PC =~ pc1 + pc2 + pc3
#   BEH =~ b1 + b2
# 
#   # Higher order latent variables
#   INT =~ ATT + SN
#   PBC =~ PC + PB
# 
#   # Higher order interaction
#   INTxPBC =~ ATT:PC + ATT:PB + SN:PC + SN:PB
# 
#   # Structural model
#   BEH ~ PBC + INT + INTxPBC
# '
# 
# est_ca <- modsem(tpb_2so, data = TPB_2SO, method = "ca")
# summary(est_ca)
# 
# est_dblcent <- modsem(tpb_2so, data = TPB_2SO, method = "dblcent")
# summary(est_dblcent)

## -----------------------------------------------------------------------------
# tpb_1so <- '
#   # First order latent variables
#   ATT =~ att1 + att2 + att3
#   SN  =~ sn1 + sn2 + sn3
#   PBC =~ pbc1 + pbc2 + pbc3
#   BEH =~ b1 + b2
# 
#   # Higher order latent variables
#   INT =~ ATT + PBC + SN
# 
#   # Higher order interaction
#   INTxPBC =~ ATT:PBC + SN:PBC + PBC:PBC
# 
#   # Structural model
#   BEH ~ PBC + INT + INTxPBC
# '
# 
# est_ca <- modsem(tpb_1so, data = TPB_1SO, method = "ca")
# summary(est_ca)
# 
# est_dblcent  <- modsem(tpb_1so, data = TPB_1SO, method = "dblcent")
# summary(est_dblcent)

