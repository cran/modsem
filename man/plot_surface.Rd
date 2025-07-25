% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_interaction.R
\name{plot_surface}
\alias{plot_surface}
\title{Plot Surface for Interaction Effects}
\usage{
plot_surface(
  x,
  z,
  y,
  xz = NULL,
  model,
  min_x = -3,
  max_x = 3,
  min_z = -3,
  max_z = 3,
  standardized = FALSE,
  detail = 0.01,
  ...
)
}
\arguments{
\item{x}{A character string specifying the name of the first predictor variable.}

\item{z}{A character string specifying the name of the second predictor variable.}

\item{y}{A character string specifying the name of the outcome variable.}

\item{xz}{Optional. A character string or vector specifying the interaction term between \code{x} and \code{z}.
If \code{NULL}, the interaction term is constructed as \code{paste(x, z, sep = ":")} and adjusted for specific model classes.}

\item{model}{A model object of class \code{\link{modsem_pi}}, \code{\link{modsem_da}}, \code{\link{modsem_mplus}}, or \code{lavaan}. The model should
include paths for the predictors (\code{x}, \code{z}, and \code{xz}) to the outcome (\code{y}).}

\item{min_x}{Numeric. Minimum value of \code{x} in z-scores. Default is -3.}

\item{max_x}{Numeric. Maximum value of \code{x} in z-scores. Default is 3.}

\item{min_z}{Numeric. Minimum value of \code{z} in z-scores. Default is -3.}

\item{max_z}{Numeric. Maximum value of \code{z} in z-scores. Default is 3.}

\item{standardized}{Should coefficients be standardized beforehand?}

\item{detail}{Numeric. Step size for the grid of \code{x} and \code{z} values, determining the resolution of the surface.
Smaller values increase plot resolution. Default is \code{1e-2}.}

\item{...}{Additional arguments passed to \code{plotly::plot_ly}.}
}
\value{
A \code{plotly} surface plot object displaying the predicted values of \code{y} across the grid of \code{x} and \code{z} values.
  The color bar shows the values of \code{y}.
}
\description{
Generates a 3D surface plot to visualize the interaction effect of two variables (\code{x} and \code{z})
on an outcome (\code{y})
using parameter estimates from a supported model object (e.g., \code{lavaan} or \code{modsem}).
The function allows specifying ranges for \code{x} and \code{z} in standardized z-scores, which are then transformed
back to the original scale based on their means and standard deviations.
}
\details{
The input \code{min_x}, \code{max_x}, \code{min_z}, and \code{max_z} define the range of \code{x} and \code{z} values in z-scores.
These are scaled by the standard deviations and shifted by the means of the respective variables, obtained
from the model parameter table. The resulting surface shows the predicted values of \code{y} over the grid of \code{x} and \code{z}.

The function supports models of class \code{modsem} (with subclasses \code{modsem_pi}, \code{modsem_da}, \code{modsem_mplus}) and \code{lavaan}.
For \code{lavaan} models, it is not designed for multigroup models, and a warning will be issued if multiple groups are detected.
}
\note{
The interaction term (\code{xz}) may need to be manually specified for some models. For non-\code{lavaan} models,
interaction terms may have their separator (\code{:}) removed based on circumstances.
}
\examples{
m1 <- "
# Outer Model
  X =~ x1 + x2 + x3
  Z =~ z1 + z2 + z3
  Y =~ y1 + y2 + y3

# Inner model
  Y ~ X + Z + X:Z
"
est1 <- modsem(m1, data = oneInt)
plot_surface("X", "Z", "Y", model = est1)

\dontrun{
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

est2 <- modsem(tpb, TPB, method = "lms", nodes = 32)
plot_surface(x = "INT", z = "PBC", y = "BEH", model = est2)
}

}
