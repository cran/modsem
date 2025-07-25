devtools::load_all()

active <- set_modsem_colors(positive = "red3", 
                            negative = "red3",
                            true = "darkgreen", 
                            false = "red3", 
                            na = "purple",
                            string = "darkgreen")

testthat::expect_true(active)

m1 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ y1 + y2 + y3
# Inner Model
  Y ~ X + Z + X:Z
"

est <- modsem(m1, data = oneInt)
colorize_output(summary(est))

colorize_output(print(est))

colorize_output(modsem_inspect(est, "coef"))


colorize_output(split = TRUE, {
  # Get live (uncolored) output
  # And print colored output at the end of execution

  est_lms <- modsem(m1, data = oneInt, method = "lms")
  summary(est_lms)
}) 
                
colorize_output(modsem_inspect(est_lms))
