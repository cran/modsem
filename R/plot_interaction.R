#' Plot Interaction Effects in a SEM Model
#'
#' This function creates an interaction plot of the outcome variable (\code{y}) as a function
#' of a focal predictor (\code{x}) at multiple values of a moderator (\code{z}). It is
#' designed for use with structural equation modeling (SEM) objects (e.g., those from
#' \code{\link{modsem}}). Predicted means (or predicted individual values) are calculated
#' via \code{\link{simple_slopes}}, and then plotted with \code{ggplot2} to display
#' multiple regression lines and confidence/prediction bands.
#'
#' @param x A character string specifying the focal predictor (x-axis variable).
#' @param z A character string specifying the moderator variable.
#' @param y A character string specifying the outcome (dependent) variable.
#' @param xz A character string specifying the interaction term (\code{x:z}).
#'   If \code{NULL}, the term is created automatically as \code{paste(x, z, sep = ":")}.
#'   Some SEM backends may handle the interaction term differently (for instance, by
#'   removing or modifying the colon), and this function attempts to reconcile that
#'   internally.
#' @param vals_x A numeric vector of values at which to compute and plot the focal
#'   predictor \code{x}. The default is \code{seq(-3, 3, .001)}, which provides a
#'   relatively fine grid for smooth lines. If \code{rescale=TRUE}, these values
#'   are in standardized (mean-centered and scaled) units, and will be converted back
#'   to the original metric in the internal computation of predicted means.
#' @param vals_z A numeric vector of values of the moderator \code{z} at which to draw
#'   separate regression lines. Each distinct value in \code{vals_z} defines a separate
#'   group (plotted with a different color). If \code{rescale=TRUE}, these values
#'   are also assumed to be in standardized units.
#' @param model An object of class \code{\link{modsem_pi}}, \code{\link{modsem_da}}, 
#'   \code{\link{modsem_mplus}}, or possibly a \code{lavaan} object. Must be a fitted
#'   SEM model containing paths for \code{y ~ x + z + x:z}.
#' @param alpha_se A numeric value in \eqn{[0, 1]} specifying the transparency of
#'   the confidence/prediction interval ribbon. Default is \code{0.15}.
#' @param digits An integer specifying the number of decimal places to which the
#'   moderator values (\code{z}) are rounded for labeling/grouping in the plot.
#' @param ci_width A numeric value in \eqn{(0,1)} indicating the coverage of the
#'   confidence (or prediction) interval. The default is \code{0.95} for a 95\%
#'   interval.
#' @param ci_type A character string specifying whether to compute
#'   \code{"confidence"} intervals (for the mean of the predicted values, default)
#'   or \code{"prediction"} intervals (which include residual variance).
#' @param rescale Logical. If \code{TRUE} (default), \code{vals_x} and \code{vals_z}
#'   are interpreted as standardized units, which are mapped back to the raw scale
#'   before computing predictions. If \code{FALSE}, \code{vals_x} and \code{vals_z}
#'   are taken as raw-scale values directly.
#' @param standardized Should coefficients be standardized beforehand?
#' @param ... Additional arguments passed on to \code{\link{simple_slopes}}.
#'
#' @details
#' \strong{Computation Steps:}
#' \enumerate{
#'   \item Calls \code{\link{simple_slopes}} to compute the predicted values of \code{y}
#'         at the specified grid of \code{x} and \code{z} values.
#'   \item Groups the resulting predictions by unique \code{z}-values (rounded to
#'         \code{digits}) to create colored lines.
#'   \item Plots these lines using \code{ggplot2}, adding ribbons for confidence
#'         (or prediction) intervals, with transparency controlled by \code{alpha_se}.
#' }
#'
#' \strong{Interpretation:}
#' Each line in the plot corresponds to the regression of \code{y} on \code{x} at
#' a given level of \code{z}. The shaded region around each line (ribbon) shows
#' either the confidence interval for the predicted mean (if \code{ci_type =
#' "confidence"}) or the prediction interval for individual observations (if
#' \code{ci_type = "prediction"}). Where the ribbons do not overlap, there is
#' evidence that the lines differ significantly over that range of \code{x}.
#'
#' @return A \code{ggplot} object that can be further customized (e.g., with
#'   additional \code{+ theme(...)} layers). By default, it shows lines for each
#'   moderator value and a shaded region corresponding to the interval type
#'   (confidence or prediction).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(modsem)
#'
#' # Example 1: Interaction of X and Z in a simple SEM
#' m1 <- "
#' # Outer Model
#'   X =~ x1 + x2 + x3
#'   Z =~ z1 + z2 + z3
#'   Y =~ y1 + y2 + y3
#'
#' # Inner Model
#'   Y ~ X + Z + X:Z
#' "
#' est1 <- modsem(m1, data = oneInt)
#'
#' # Plot interaction using a moderate range of X and two values of Z
#' plot_interaction(x = "X", z = "Z", y = "Y", xz = "X:Z",
#'                  vals_x = -3:3, vals_z = c(-0.2, 0), model = est1)
#'
#' # Example 2: Interaction in a theory-of-planned-behavior-style model
#' tpb <- "
#' # Outer Model
#'   ATT =~ att1 + att2 + att3 + att4 + att5
#'   SN  =~ sn1 + sn2
#'   PBC =~ pbc1 + pbc2 + pbc3
#'   INT =~ int1 + int2 + int3
#'   BEH =~ b1 + b2
#'
#' # Inner Model
#'   INT ~ ATT + SN + PBC
#'   BEH ~ INT + PBC
#'   BEH ~ PBC:INT
#' "
#' est2 <- modsem(tpb, data = TPB, method = "lms", nodes = 32)
#'
#' # Plot with custom Z values and a denser X grid
#' plot_interaction(x = "INT", z = "PBC", y = "BEH",
#'                  xz = "PBC:INT",
#'                  vals_x = seq(-3, 3, 0.01),
#'                  vals_z = c(-0.5, 0.5),
#'                  model = est2)
#' }
plot_interaction <- function(x, z, y, xz = NULL, vals_x = seq(-3, 3, .001),
                             vals_z, model, alpha_se = 0.15, digits = 2, 
                             ci_width = 0.95, ci_type = "confidence", rescale = TRUE, 
                             standardized = FALSE, ...) {
  slopes <- simple_slopes(x = x, z = z, y = y, model = model, vals_x = vals_x, vals_z = vals_z, 
                          rescale = rescale, ci_width = ci_width, ci_type = ci_type, 
                          standardized = standardized, ...)
  df <- as.data.frame(slopes)
  df$cat_z <- as.factor(round(df$vals_z, digits))

  # declare within the scope, to not get notes in R CMD check
  std.error <- df$std.error
  predicted <- df$predicted
  cat_z     <- df$cat_z
  vals_x    <- df$vals_x
  ci.lower  <- df$ci.lower
  ci.upper  <- df$ci.upper

  # plotting margins
  ggplot2::ggplot(df, ggplot2::aes(x = vals_x, y = predicted, colour = cat_z, group = cat_z)) +
    ggplot2::geom_smooth(method = "lm", formula = "y ~ x", se = FALSE) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = ci.lower, ymax = ci.upper, fill = cat_z),
                         alpha = alpha_se, linewidth = 0, linetype = "blank") +
    ggplot2::labs(x = x, y = y, colour = z, fill = z) + 
    ggplot2::ggtitle(sprintf("Marginal Effects of %s on %s, Given %s", x, y, z)) + 
    ggplot2::theme_bw()
}


#' Plot Interaction Effect Using the Johnson-Neyman Technique
#'
#' This function plots the simple slopes of an interaction effect across different values of a moderator variable using the Johnson-Neyman technique. It identifies regions where the effect of the predictor on the outcome is statistically significant.
#'
#' @param x The name of the predictor variable (as a character string).
#' @param z The name of the moderator variable (as a character string).
#' @param y The name of the outcome variable (as a character string).
#' @param xz The name of the interaction term. If not specified, it will be created using \code{x} and \code{z}.
#' @param model A fitted model object of class \code{modsem_da}, \code{modsem_mplus}, \code{modsem_pi}, or \code{lavaan}.
#' @param min_z The minimum value of the moderator variable \code{z} to be used in the plot (default is -3). It is relative to the mean of z.
#' @param max_z The maximum value of the moderator variable \code{z} to be used in the plot (default is 3). It is relative to the mean of z.
#' @param sig.level The alpha-criterion for the confidence intervals (default is 0.05).
#' @param alpha alpha setting used in \code{ggplot} (i.e., the opposite of opacity)
#' @param detail The number of generated data points to use for the plot (default is 1000). You can increase this value for smoother plots.
#' @param sd.line A thick black line showing \code{+/- sd.line * sd(z)}. NOTE: This line will be truncated by \code{min_z} and \code{max_z} if 
#' the sd.line falls outside of \code{[min_z, max_z]}.
#' @param standardized Should coefficients be standardized beforehand?
#' @param ... Additional arguments (currently not used).
#' @return A \code{ggplot} object showing the interaction plot with regions of significance.
#' @details
#' The function calculates the simple slopes of the predictor variable \code{x} on the outcome variable \code{y} at different levels of the moderator variable \code{z}. It uses the Johnson-Neyman technique to identify the regions of \code{z} where the effect of \code{x} on \code{y} is statistically significant.
#'
#' It extracts the necessary coefficients and variance-covariance information from the fitted model object. The function then computes the critical t-value and solves the quadratic equation derived from the t-statistic equation to find the Johnson-Neyman points.
#'
#' The plot displays:
#' \itemize{
#'   \item The estimated simple slopes across the range of \code{z}.
#'   \item Confidence intervals around the slopes.
#'   \item Regions where the effect is significant (shaded areas).
#'   \item Vertical dashed lines indicating the Johnson-Neyman points.
#'   \item Text annotations providing the exact values of the Johnson-Neyman points.
#' }
#'
#' @examples
#' \dontrun{
#' library(modsem)
#'
#' m1 <-  ' 
#'   visual  =~ x1 + x2 + x3 
#'   textual =~ x4 + x5 + x6
#'   speed   =~ x7 + x8 + x9
#' 
#'   visual ~ speed + textual + speed:textual
#' '
#' 
#' est <- modsem(m1, data = lavaan::HolzingerSwineford1939, method = "ca")
#' plot_jn(x = "speed", z = "textual", y = "visual", model = est, max_z = 6)
#' }
#' @importFrom ggplot2 ggplot aes geom_line geom_ribbon geom_vline annotate scale_fill_manual labs theme_minimal
#' @export
plot_jn <- function(x, z, y, xz = NULL, model, min_z = -3, max_z = 3, 
                    sig.level = 0.05, alpha = 0.2, detail = 1000, 
                    sd.line = 2, standardized = FALSE, ...) {
  # Check if model is a valid object
  stopif(!inherits(model, c("modsem_da", "modsem_mplus", "modsem_pi", "lavaan")),
         "model must be of class 'modsem_pi', 'modsem_da', 'modsem_mplus', or 'lavaan'")

  # If interaction term is not specified, create it
  if (is.null(xz)) xz <- paste(x, z, sep = ":")
  xz <- c(xz, reverseIntTerm(xz))
  if (!inherits(model, c("modsem_da", "modsem_mplus")) && !inherits(model, "lavaan")) {
    xz <- stringr::str_remove_all(xz, ":")
  }
    
  if (inherits(model, "lavaan")) {
    vcov <- lavaan::vcov
    coef <- lavaan::coef
    nobs <- lavaan::nobs
  }

  if (standardized) {
    parTable <- standardized_estimates(model, correction = TRUE)
  } else parTable <- parameter_estimates(model)
  parTable <- getMissingLabels(parTable)

  # mean and sd x
  mean_z <- getMean(z, parTable = parTable)
  sd_z   <- sqrt(calcCovParTable(x = z, y = z, parTable = parTable))
  min_z  <- min_z + mean_z
  max_z  <- max_z + mean_z

  # Extract coefficients
  beta_x <- parTable[parTable$lhs == y & parTable$rhs == x & parTable$op == "~", "est"]
  beta_xz <- parTable[parTable$lhs == y & parTable$rhs %in% xz & parTable$op == "~", "est"]

  stopif(length(beta_x) == 0, "Coefficient for x not found in model")
  stopif(length(beta_xz) == 0, "Coefficient for interaction term not found in model")

  # Extract variance-covariance matrix
  VCOV <- vcov(model)

  label_beta_x  <- parTable[parTable$lhs == y & parTable$rhs == x & parTable$op == "~", "label"]
  label_beta_xz <- parTable[parTable$lhs == y & parTable$rhs %in% xz & parTable$op == "~", "label"]

  # Extract variances and covariances
  var_beta_x         <- VCOV[label_beta_x, label_beta_x]
  var_beta_xz        <- VCOV[label_beta_xz, label_beta_xz]
  cov_beta_x_beta_xz <- VCOV[label_beta_x, label_beta_xz]

  nobs <- nobs(model)
  npar <- length(coef(model))

  df_resid <- nobs - npar
  
  if (df_resid < 1) {
    warning2("Degrees of freedom for residuals must be greater than 0. ",
             "The model may have fewer observations than parameters.\n",
             "Using sample size instead of degrees of freedom")
    df_resid <- nobs
  }

  # Critical t-value
  t_crit <- stats::qt(1 - sig.level / 2, df_resid)

  # Quadratic equation components
  A <- beta_xz^2 - t_crit^2 * var_beta_xz
  B <- 2 * beta_x * beta_xz - 2 * t_crit^2 * cov_beta_x_beta_xz
  C <- beta_x^2 - t_crit^2 * var_beta_x

  discriminant <- B^2 - 4 * A * C

  if (A == 0) {
    # Linear case
    if (B != 0) {
      z_jn <- -C / B
      significant_everywhere <- FALSE
      z_lower <- z_jn
      z_upper <- z_jn
    } else {
      message("No regions where the effect transitions between significant and non-significant.")
      significant_everywhere <- TRUE
    }
  } else if (discriminant < 0) {
    message("No regions where the effect transitions between significant and non-significant.")
    significant_everywhere <- TRUE

  } else if (discriminant == 0) {
    # One real root
    z_jn <- -B / (2 * A)
    significant_everywhere <- FALSE
    z_lower <- z_jn
    z_upper <- z_jn
  } else {
    # Two real roots
    z1 <- (-B + sqrt(discriminant)) / (2 * A)
    z2 <- (-B - sqrt(discriminant)) / (2 * A)
    z_lower <- min(z1, z2)
    z_upper <- max(z1, z2)
    significant_everywhere <- FALSE
  }

  z_range <- seq(min_z, max_z, length.out = detail)

  # if not defined here (as opposed to only in the dataframe) we will get 
  # some bogus notes in the R CMD check
  slope         <- beta_x + beta_xz * z_range
  SE_slope      <- sqrt(var_beta_x + z_range ^ 2 * var_beta_xz + 2 * z_range * cov_beta_x_beta_xz)
  t_value       <- slope / SE_slope
  p_value       <- 2 * (1 - stats::pt(abs(t_value), df_resid))
  significant   <- p_value < sig.level
  lower_all     <- slope - t_crit * SE_slope
  upper_all     <- slope + t_crit * SE_slope
  lower_sig     <- ifelse(significant,  lower_all, NA)
  upper_sig     <- ifelse(significant,  upper_all, NA)
  lower_sig     <- ifelse(significant, lower_all, NA)
  upper_sig     <- ifelse(significant, upper_all, NA)
  lower_nsig    <- ifelse(!significant, lower_all, NA)
  upper_nsig    <- ifelse(!significant, upper_all, NA)
  significance  <- ifelse(significant, sprintf("p < %s", sig.level), "n.s.")
  line_segments <- cumsum(c(0, diff(as.numeric(significant)) != 0))

  # Create the data frame
  df_plot <- data.frame(
      z            = z_range,
      slope        = slope,
      SE           = SE_slope,
      t            = t_value,
      p            = p_value,
      significant  = significant,
      upper_all    = upper_all,
      lower_all    = lower_all,
      upper_sig    = upper_sig,
      lower_sig    = lower_sig,
      upper_nsig   = upper_nsig,
      lower_nsig   = lower_nsig,
      Significance = significance,
      # Really f***ing ugly, but works... (if not the line will sometimes be 
      # on color...)
      line_segments = line_segments
  )
  
  # get info for thick line segment
  x_start <- mean_z - sd.line * sd_z
  x_end   <- mean_z + sd.line * sd_z

  if (x_start < min_z && x_end > max_z) {
    warning2("Truncating SD-range on the right and left!")
  } else if (x_start < min_z) {
    warning2("Truncating SD-range on the left!")
  } else if (x_end > max_z) {
    warning2("Truncating SD-range on the right!")
  }

  x_start     <- max(x_start, min_z)
  x_end       <- min(x_end, max_z)
  y_start     <- y_end <- 0
  hline_label <- sprintf("+/- %s SDs of %s", sd.line, z)

  data_hline <- data.frame(x_start = x_start, x_end = x_end, 
                           y_start = y_start, y_end = y_end,
                           hline_label = hline_label)

  siglabel <- sprintf("p < %s", sig.level)
  breaks   <- c(siglabel, "n.s.", hline_label)
  values   <- structure(c("cyan3", "red", "black"), names = breaks)

  p <- ggplot2::ggplot(df_plot, ggplot2::aes(x = z, y = slope)) +
    ggplot2::geom_line(ggplot2::aes(color = significance, group = line_segments), linewidth = 1) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower_nsig, ymax = upper_nsig, fill = "n.s."), alpha = alpha) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower_sig, ymax = upper_sig, fill = sprintf("p < %s", sig.level)), alpha = alpha) +
    ggplot2::labs(x = z, y = paste("Slope of", x, "on", y)) +
    ggplot2::geom_hline(yintercept = 0, color="black", linewidth = 0.5) + 
    suppressWarnings(ggplot2::geom_segment(
        mapping = aes(x = x_start, xend = x_end, y = y_start, yend = y_end, 
                      color = hline_label, fill = hline_label), 
        data = data_hline, linewidth = 1.5)
    ) + 
    ggplot2::ggtitle("Johnson-Neyman Plot") +
    ggplot2::scale_fill_manual(name = "", values = values, breaks = breaks) +
    ggplot2::scale_color_manual(name = "", values = values, breaks = breaks) +
    ggplot2::guides(fill = ggplot2::guide_legend(title = ""),
                    color = ggplot2::guide_legend(title = "")) +
    ggplot2::theme_minimal()


  if (!significant_everywhere) {
    if (exists("z_jn")) {
      # Single JN point
      if (z_jn >= min_z && z_jn <= max_z) {
        p <- p + ggplot2::geom_vline(xintercept = z_jn, linetype = "dashed", color = "red") +
          ggplot2::annotate("text", x = z_jn, y = max(df_plot$slope), label = paste("JN point:", round(z_jn, 2)),
                            hjust = -0.1, vjust = 1, color = "black")
      }
    } else {
      # Two JN points
      if (z_lower >= min_z && z_lower <= max_z) {
        p <- p +
          ggplot2::geom_vline(xintercept = z_lower, linetype = "dashed", color = "red") +
          ggplot2::annotate("text", x = z_lower, y = max(df_plot$slope), label = paste("JN point:", round(z_lower, 2)),
                            hjust = -0.1, vjust = 1, color = "black")
      }
      if (z_upper >= min_z && z_upper <= max_z) {
        p <- p +
          ggplot2::geom_vline(xintercept = z_upper, linetype = "dashed", color = "red") +
          ggplot2::annotate("text", x = z_upper, y = max(df_plot$slope), label = paste("JN point:", round(z_upper, 2)),
                            hjust = -0.1, vjust = 1, color = "black")
      }
    }
  }

  p
}


#' Plot Surface for Interaction Effects
#'
#' Generates a 3D surface plot to visualize the interaction effect of two variables (\code{x} and \code{z})
#' on an outcome (\code{y})
#' using parameter estimates from a supported model object (e.g., \code{lavaan} or \code{modsem}).
#' The function allows specifying ranges for \code{x} and \code{z} in standardized z-scores, which are then transformed
#' back to the original scale based on their means and standard deviations.
#'
#' @param x A character string specifying the name of the first predictor variable.
#' @param z A character string specifying the name of the second predictor variable.
#' @param y A character string specifying the name of the outcome variable.
#' @param xz Optional. A character string or vector specifying the interaction term between \code{x} and \code{z}.
#'   If \code{NULL}, the interaction term is constructed as \code{paste(x, z, sep = ":")} and adjusted for specific model classes.
#' @param model A model object of class \code{\link{modsem_pi}}, \code{\link{modsem_da}}, \code{\link{modsem_mplus}}, or \code{lavaan}. The model should
#'   include paths for the predictors (\code{x}, \code{z}, and \code{xz}) to the outcome (\code{y}).
#' @param min_x Numeric. Minimum value of \code{x} in z-scores. Default is -3.
#' @param max_x Numeric. Maximum value of \code{x} in z-scores. Default is 3.
#' @param min_z Numeric. Minimum value of \code{z} in z-scores. Default is -3.
#' @param max_z Numeric. Maximum value of \code{z} in z-scores. Default is 3.
#' @param standardized Should coefficients be standardized beforehand?
#' @param detail Numeric. Step size for the grid of \code{x} and \code{z} values, determining the resolution of the surface.
#'   Smaller values increase plot resolution. Default is \code{1e-2}.
#' @param ... Additional arguments passed to \code{plotly::plot_ly}.
#'
#' @details
#' The input \code{min_x}, \code{max_x}, \code{min_z}, and \code{max_z} define the range of \code{x} and \code{z} values in z-scores.
#' These are scaled by the standard deviations and shifted by the means of the respective variables, obtained
#' from the model parameter table. The resulting surface shows the predicted values of \code{y} over the grid of \code{x} and \code{z}.
#'
#' The function supports models of class \code{modsem} (with subclasses \code{modsem_pi}, \code{modsem_da}, \code{modsem_mplus}) and \code{lavaan}.
#' For \code{lavaan} models, it is not designed for multigroup models, and a warning will be issued if multiple groups are detected.
#'
#' @return A \code{plotly} surface plot object displaying the predicted values of \code{y} across the grid of \code{x} and \code{z} values.
#'   The color bar shows the values of \code{y}.
#'
#' @note
#' The interaction term (\code{xz}) may need to be manually specified for some models. For non-\code{lavaan} models,
#' interaction terms may have their separator (\code{:}) removed based on circumstances.
#'
#' @examples
#' m1 <- "
#' # Outer Model
#'   X =~ x1 + x2 + x3
#'   Z =~ z1 + z2 + z3
#'   Y =~ y1 + y2 + y3
#'
#' # Inner model
#'   Y ~ X + Z + X:Z
#' "
#' est1 <- modsem(m1, data = oneInt)
#' plot_surface("X", "Z", "Y", model = est1)
#'
#' \dontrun{
#' tpb <- "
#' # Outer Model (Based on Hagger et al., 2007)
#'   ATT =~ att1 + att2 + att3 + att4 + att5
#'   SN =~ sn1 + sn2
#'   PBC =~ pbc1 + pbc2 + pbc3
#'   INT =~ int1 + int2 + int3
#'   BEH =~ b1 + b2
#' 
#' # Inner Model (Based on Steinmetz et al., 2011)
#'   INT ~ ATT + SN + PBC
#'   BEH ~ INT + PBC
#'   BEH ~ PBC:INT
#' "
#' 
#' est2 <- modsem(tpb, TPB, method = "lms", nodes = 32)
#' plot_surface(x = "INT", z = "PBC", y = "BEH", model = est2)
#' }
#'
#' @export
plot_surface <- function(x, z, y, xz = NULL, model, 
                         min_x = -3, max_x = 3, 
                         min_z = -3, max_z = 3,
                         standardized = FALSE, 
                         detail = 1e-2, ...) {
  stopif(!isModsemObject(model) && !isLavaanObject(model), "model must be of class ",
         "'modsem_pi', 'modsem_da', 'modsem_mplus' or 'lavaan'")

  if (is.null(xz)) xz <- paste(x, z, sep = ":")
  xz <- c(xz, reverseIntTerm(xz))
  if (!inherits(model, c("modsem_da", "modsem_mplus")) &&
      !isLavaanObject(model)) {
    xz <- stringr::str_remove_all(xz, ":")
  }

  if (standardized) {
    parTable <- standardized_estimates(model, correction = TRUE)
  } else parTable <- parameter_estimates(model)

  if (isLavaanObject(model)) {
    # this won't work for multigroup models
    nobs <- unlist(model@Data@nobs)
    warnif(length(nobs) > 1, "plot_interaction is not intended for multigroup models")
    n <- nobs[[1]]

  } else {
    n <- nrow(model$data)
  }

  lVs <- c(x, z, y, xz)
  coefs <- parTable[parTable$op == "~" & parTable$rhs %in% lVs &
                    parTable$lhs == y, ]
  gamma_x  <- coefs[coefs$rhs == x, "est"]
  sd_x     <- sqrt(calcCovParTable(x, x, parTable))
  gamma_z  <- coefs[coefs$rhs == z, "est"]
  sd_z     <- sqrt(calcCovParTable(z, z, parTable))
  gamma_xz <- coefs[coefs$rhs %in% xz, "est"]

  stopif(!length(gamma_x),  "coefficient for x not found in model")
  stopif(!length(sd_x),    "variance of x not found in model")
  stopif(!length(gamma_z),  "coefficient for z not found in model")
  stopif(!length(sd_z),    "variance of z not found in model")
  stopif(!length(gamma_xz), "coefficient for xz not found in model")

  # offset by mean
  mean_x <- getMean(x, parTable = parTable)
  mean_z <- getMean(z, parTable = parTable)
  vals_x <- sd_x * seq(min_x, max_x, by = detail) + mean_x
  vals_z <- sd_z * seq(min_z, max_z, by = detail) + mean_z

  proj_y <- outer(vals_x, vals_z, \(x, z) gamma_x * x + gamma_z + z + z * x * gamma_xz)

  plotly::plot_ly(z = ~proj_y, x = ~vals_x, y = ~vals_z, type = "surface",
                  colorbar = list(title = y)) |>
    plotly::layout(title = sprintf("Surface Plot of Interaction Effect between %s and %s, on %s", x, z, y),
                   scene = list(xaxis = list(title = x),
                                zaxis = list(title = y),
                                yaxis = list(title = z)))
}


# Helper function to reverse interaction term
reverseIntTerm <- function(xz) {
  if (grepl(":", xz)) {
    vars <- strsplit(xz, ":")[[1]]
    rev_xz <- paste(rev(vars), collapse = ":")
  } else {
    rev_xz <- xz
  }
  rev_xz
}
