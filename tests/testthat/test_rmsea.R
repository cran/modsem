devtools::load_all()
m1 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ 1.1*y1 + 1*y2 + y3

# Inner model
  Y ~ X + Z

  y2 ~ 1.3 * 1
"

est_lms <- modsem(m1, data = oneInt, method = "lms", calc.se=FALSE)
fit_mod <- fit_modsem_da(est_lms)

est_lavaan <- lavaan::sem(m1, data = oneInt, meanstructure = TRUE)
fit_lav <- as.list(lavaan::lavInspect(est_lavaan, "fit"))

expect_equal <- function(x, y, tolerance) {
  diff <- abs(x - y)
  ok <- diff <= tolerance
  cat(sprintf("x: %8.4f, y: %8.4f, y-x: %7.4f, y-x < tol: %s\n", x, y, y - x, ok))
  testthat::expect_equal(x, y, tolerance = tolerance)
}

compare_fits <- function(fit_mod, fit_lav) {
  expect_equal(fit_mod$chisq.value, fit_lav$chisq, tolerance = .2)
  expect_equal(fit_mod$chisq.df, fit_lav$df, tolerance = 0)
  expect_equal(fit_mod$RMSEA, fit_lav$rmsea, tolerance = .0001)
  expect_equal(fit_mod$RMSEA, fit_lav$rmsea, tolerance = .0001)
  expect_equal(fit_mod$RMSEA.pvalue, fit_lav$rmsea.pvalue, tolerance = .0001)
  expect_equal(fit_mod$RMSEA.lower, fit_lav$rmsea.ci.lower, tolerance = .0001)
  expect_equal(fit_mod$RMSEA.upper, fit_lav$rmsea.ci.upper, tolerance = .0001)
}

compare_fits(fit_mod, fit_lav)

m2 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ 1.1*y1 + 1*y2 + y3

# Inner model
  Y ~ X + Z
"
est_lms2 <- modsem(m2, data = oneInt, method = "lms", calc.se=FALSE,
                   mean.observed = FALSE)
est_lavaan2 <- lavaan::sem(m2, data = oneInt)

fit_lav2 <- as.list(lavaan::lavInspect(est_lavaan2, "fit"))
fit_mod2 <- fit_modsem_da(est_lms2)
compare_fits(fit_mod2, fit_lav2)
