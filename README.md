‚# ModSEM
This is a package which allows you to perform interactions between latent variables (i.e., moderation) in CB-SEM. See https://bookdown.org/slupphaugkjell/quartomodsem/ for a tutorial.

# To Install 
```
install.packages("devtools")
devtools::install_github("kss2k/modsem")
```

# Methods/Approaches

There are a number of approaches for estimating interaction effects in SEM. In `modsem()`, the `method = "method"` argument allows you to choose which to use.

- "ca" = constrained approach (Algina & Moulder, 2001)
    - Note that constraints can become quite complicated for complex models, 
      particularly when there is an interaction including enodgenous variables.
      The method can therefore be quite slow. 
- "uca" = unconstrained approach (Marsh, 2004)
- "rca" = residual centering approach (Little et al., 2006)
- "dblcent" = double centering approach (Marsh., 2013)
  - default
- "pind" = basic product indicator approach (not recommended)
- "lms" = The latent moderated structural equations approach through the nlsem package
  - note: can only be done if you have a single endogenous (dependent) variable. 
  - do `qml = TRUE` for the quasi maximum likelihood version
  - do `optimize = TRUE` for faster convergence (experimental feature)
- "mplus" 
  - estimates model through Mplus, if it is installed


# Examples 

## One interaction
```
library(modsem)
m1 <- '
  # Outer Model
  X =~ x1 + x2 +x3
  Y =~ y1 + y2 + y3
  Z =~ z1 + z2 + z3
  
  # Inner model
  Y ~ X + Z + X:Z 
'

est1 <- modsem(m1, oneInt)
summary(est1)
```

## Interactions between two observed variables
```
est2 <- modsem('y1 ~ x1 + z1 + x1:z1', data = oneInt, method = "pind")
summary(est2)

## Interaction between an obsereved and a latent variable 
m3 <- '
  # Outer Model
  X =~ x1 + x2 +x3
  Y =~ y1 + y2 + y3
  
  # Inner model
  Y ~ X + z1 + X:z1 
'

est3 <- modsem(m3, oneInt, method = "pind")
summary(est3)
```

## Multiple interaction terms
```
m4 <- '
  # Outer Model
  X =~ x1 + x2 +x3
  Y =~ y1 + y2 + y3
  Z =~ z1 + z2 + z3
  G =~ g1 + g2 + g3
  H =~ h1 + h2 + h3
  
  # Inner model
  Y ~ X + Z + G + H + X:Z + G:H
'

est4 <- modsem(m4, twoInt)
summary(est4)
```

## Interactionterms with more than two variables
```
m5 <- '
  # Outer Model
  X =~ x1 + x2 +x3
  Y =~ y1 + y2 + y3
  Z =~ z1 + z2 + z3
  G =~ g1 + g2 + g3
  
  # Inner model
  Y ~ X + Z + G + X:Z:G
'

est5 <- modsem(m5, tripleInt, standardizeData = TRUE)
summary(est5)
```
