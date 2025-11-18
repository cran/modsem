## ----include = FALSE----------------------------------------------------------
EVAL_DEFAULT <- FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = TRUE
)

## ----model--------------------------------------------------------------------
library(modsem)
library(ggplot2)

m <- '
X =~ x1 + x2 + x3
Z =~ z1 + z2 + z3
Y =~ y1 + y2 + y3

Y ~ X + Z + X:Z
'

fit <- modsem(m, data = oneInt, method = "lms")
p <- plot_interaction(x = "X", z = "Z", y = "Y", vals_z = c(-1, 1), model = fit)
print(p)

## ----plot-title, echo=FALSE---------------------------------------------------
p + ggtitle("This is a new title")

## ----axis-labels, echo=FALSE--------------------------------------------------
p + xlab("This is the x-axis") + ylab("This is the y-axis")

## -----------------------------------------------------------------------------
p + guides(fill=guide_legend(title = "New Legend Title"),
           color=guide_legend(title = "New Legend Title"))

## -----------------------------------------------------------------------------
p + scale_fill_grey()

## -----------------------------------------------------------------------------
p + scale_color_grey()

## -----------------------------------------------------------------------------
p + scale_color_grey() + scale_fill_grey()

## ----fig.height = 18, fig.width = 8-------------------------------------------
# You might need to install the `RColorBrewer` package
RColorBrewer::display.brewer.all()

## -----------------------------------------------------------------------------
# We need to apply the color scale to both the fill and color aesthetics
p + scale_fill_brewer(palette = "Dark2") +
    scale_color_brewer(palette = "Dark2")

## -----------------------------------------------------------------------------
# We need to apply the color scale to both the fill and color aesthetics
p + scale_fill_brewer(palette = "Accent") +
    scale_color_brewer(palette = "Accent")

## -----------------------------------------------------------------------------
custom_colors = c("#E69F00", "#56B4E9")

p + scale_fill_manual(values = custom_colors) +
    scale_color_manual(values = custom_colors)

## -----------------------------------------------------------------------------
p + aes(linetype = cat_z)

## -----------------------------------------------------------------------------
p + aes(linetype = cat_z) +
    guides(linetype = guide_legend("Z"))

## -----------------------------------------------------------------------------
p +
  ggtitle("Customized Plot") + # New Title
  xlab("Values of X") + # New X-axis label
  ylab("Predicted values of Y") + # New y-axis label
  scale_color_grey() + # Add Grey theem
  scale_fill_grey() +
  aes(linetype = cat_z) + # Add linetypes
  guides(color    = guide_legend("Values of Z"), # Change Legend Title
         fill     = guide_legend("Values of Z"),
         linetype = guide_legend("Values of Z"))

