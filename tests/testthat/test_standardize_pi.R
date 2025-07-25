devtools::load_all()

m1 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ y1 + y2 + y3
# Inner Model
  Y ~ X + Z + a * X:Z

  c := a
"

est <- modsem(m1, data = oneInt)
parTable <- standardized_estimates(est)
parTable <- standardized_estimates(est, correction = TRUE)
parTable <- standardized_estimates(est, correction = TRUE, std.errors = "delta")
summarize_partable(parTable)

standardized_estimates(est, correction = TRUE, std.errors = "monte.carlo", mc.reps=10000)

varXZ <- parTable[parTable$lhs == "XZ" & parTable$rhs == "XZ", "est"]
testthat::expect_true(varXZ > 1.02)
testthat::expect_equal(unname(calcVarParTable("Y", parTable)), 1)

a <- parTable[parTable$label == "a", "est"]
c <- parTable[parTable$label == "c", "est"]

testthat::expect_equal(a, c)

a <- parTable[parTable$label == "a", "est"]
c <- parTable[parTable$label == "c", "est"]

testthat::expect_equal(a, c)

m2 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ y1 + y2 + y3
# Inner Model
  Y ~ X + Z + X:Z + X:X
"

est <- modsem(m2, data = oneInt)
parTable <- standardized_estimates(est, correction = TRUE)
parTable <- standardized_estimates(est, correction = TRUE, std.errors = "delta")
varXZ <- parTable[parTable$lhs == "XZ" & parTable$rhs == "XZ", "est"]
varXX <- parTable[parTable$lhs == "XX" & parTable$rhs == "XX", "est"]
testthat::expect_true(varXZ > 1.02)
testthat::expect_true(varXX > 1.7)
testthat::expect_equal(unname(calcVarParTable("Y", parTable)), 1)


m3 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Y =~ y1 + y2 + y3
# Inner Model
  Y ~ X + z1 + a * X:z1

  c := a
"

est <- modsem(m3, data = oneInt, method = "pind")
parTable <- standardized_estimates(est)
parTable <- standardized_estimates(est, correction = TRUE)
parTable <- standardized_estimates(est, correction = TRUE, std.errors = "delta")
summarize_partable(parTable)

varz1 <- parTable[parTable$lhs == "z1" & parTable$rhs == "z1", "est"]
varXz1 <- parTable[parTable$lhs == "Xz1" & parTable$rhs == "Xz1", "est"]
testthat::expect_true(varXz1 > 2)
testthat::expect_equal(varz1, 1)
testthat::expect_equal(unname(calcVarParTable("Y", parTable)), 1)


m4 <- "
# Outer Model
  X =~ x1 + x2 + x3
# Inner Model
  y1 ~ X + z1 + a * X:z1

  c := a
"

est <- modsem(m4, data = oneInt, method = "pind")
parTable <- standardized_estimates(est)
parTable <- standardized_estimates(est, correction = TRUE)
parTable <- standardized_estimates(est, correction = TRUE, std.errors = "delta")
summarize_partable(parTable)

varz1 <- parTable[parTable$lhs == "z1" & parTable$rhs == "z1", "est"]
varXz1 <- parTable[parTable$lhs == "Xz1" & parTable$rhs == "Xz1", "est"]
testthat::expect_true(varXz1 > 2)
testthat::expect_equal(varz1, 1)
testthat::expect_equal(unname(calcVarParTable("y1", parTable)), 1)


m5 <- "
  y1 ~ x1 + z1 + a * x1:z1
  c := a
"

est <- modsem(m5, data = oneInt, method = "dblcent")
parTable <- standardized_estimates(est)
parTable <- standardized_estimates(est, correction = TRUE)
parTable <- standardized_estimates(est, correction = TRUE, std.errors = "delta")
summarize_partable(parTable)

varz1 <- parTable[parTable$lhs == "z1" & parTable$rhs == "z1", "est"]
varx1z1 <- parTable[parTable$lhs == "x1z1" & parTable$rhs == "x1z1", "est"]
testthat::expect_true(varx1z1 > 1)
testthat::expect_equal(varz1, 1)
testthat::expect_equal(unname(calcVarParTable("y1", parTable)), 1)
