MODSEM_COLORS <- rlang::env(
  # user-configurable color names
  positive = NA_character_,
  negative = NA_character_,
  true     = NA_character_,
  false    = NA_character_,
  nan      = NA_character_,
  na       = NA_character_,
  inf      = NA_character_,
  string   = NA_character_,

  # run-time flags & helpers
  active   = FALSE,
  available = NULL,

  # pre-compiled styling functions (identity placeholders)
  f.positive = \(x) x,
  f.negative = \(x) x,
  f.true     = \(x) x,
  f.false    = \(x) x,
  f.nan      = \(x) x,
  f.na       = \(x) x,
  f.inf      = \(x) x,
  f.string   = \(x) x
)


PATTERN.pos    <- "(?<![-+A-Za-z0-9._~])([0-9]+(?:[.-][0-9]+)*(?:\\.[0-9]*)?(?:[eE][+-]?[0-9]+)?)(?![A-Za-z])"
PATTERN.neg    <- "(?<![-+A-Za-z0-9._~])(-[0-9]+(?:[.-][0-9]+)*(?:\\.[0-9]*)?(?:[eE][+-]?[0-9]+)?)(?![A-Za-z])"
PATTERN.TRUE   <- "(?<![A-Za-z0-9])TRUE(?![A-Za-z0-9])"
PATTERN.FALSE  <- "(?<![A-Za-z0-9])FALSE(?![A-Za-z0-9])"
PATTERN.NaN    <- "(?<![A-Za-z0-9])NaN(?![A-Za-z0-9])"
PATTERN.NA     <- "(?<![A-Za-z0-9])NA(?![A-Za-z0-9])"
PATTERN.Inf    <- "(?<![A-Za-z0-9])-?Inf(?![A-Za-z0-9])"
PATTERN.String <- "(\"(?:[^\"\\\\]|\\\\.)*\"|'(?:[^'\\\\]|\\\\.)*')"


setAvailableColors <- function() {
  MODSEM_COLORS$available <- grDevices::colors()
}


styleOrAsIs <- function(col) {
  if (is.na(col)) return(\(x) x)
  cli::make_ansi_style(col)
}


getColorizedASCII <- function(col) {
  if (is.na(col)) return("\\0") # no color -> leave as-is
  as.character(cli::make_ansi_style(col)("\\0"))
}


resetModsemColors <- function() {
  MODSEM_COLORS$active <- FALSE
  fields <- c("positive","negative","true","false","nan","na","inf","string")
  for (f in fields) MODSEM_COLORS[[f]] <- NA_character_

  funs <- grep("^f\\.", names(MODSEM_COLORS), value = TRUE)
  for (f in funs)  MODSEM_COLORS[[f]] <- \(x) x

  setAvailableColors()
}


captureOutput <- function (expr, envir = parent.frame(), split = FALSE) {
  # Capture output using a raw connections, as it is exponentially faster 
  # for large outputs
  eval({
    file <- rawConnection(raw(0L), open = "w")
    
    on.exit(if (!is.null(file)) close(file))

    utils::capture.output(expr, file = file, split = split)
    
    res <- rawConnectionValue(file)
    close(file)
    file <- NULL
  
    rawToChar(res)

  }, envir = envir, enclos = envir)
}


#' Define or disable the color theme used by \code{modsem}
#'
#' All arguments are optional; omitted ones fall back to the defaults below.
#' Pass \code{active = FALSE} to turn highlighting off (and reset the palette).
#'
#' @param positive color of positive numbers.
#' @param negative color of negative numbers.
#' @param true color of \code{TRUE}.
#' @param false color of \code{FALSE}.
#' @param nan color of \code{NaN}.
#' @param na color of \code{NA}.
#' @param inf color of \code{-Inf} and \code{Inf}.
#' @param string color of quoted strings.
#' @param active Should color-theme be activated/deactived? 
#'
#' @examples
#' set_modsem_colors(positive = "red3", 
#'                   negative = "red3",
#'                   true = "darkgreen", 
#'                   false = "red3", 
#'                   na = "purple",
#'                   string = "darkgreen")
#' 
#' m1 <- "
#' # Outer Model
#'   X =~ x1 + x2 + x3
#'   Z =~ z1 + z2 + z3
#'   Y =~ y1 + y2 + y3
#' # Inner Model
#'   Y ~ X + Z + X:Z
#' "
#' 
#' est <- modsem(m1, data = oneInt)
#' colorize_output(summary(est))
#' colorize_output(est) # same as colorize_output(print(est))
#' colorize_output(modsem_inspect(est, what = "coef"))
#'
#' \dontrun{
#' colorize_output(split = TRUE, {
#'   # Get live (uncolored) output
#'   # And print colored output at the end of execution
#' 
#'   est_lms <- modsem(m1, data = oneInt, method = "lms")
#'   summary(est_lms)
#' }) 
#'                 
#' colorize_output(modsem_inspect(est_lms))
#' }
#' @return \code{TRUE} if colors are active afterwards, otherwise \code{FALSE}.
#' @export
set_modsem_colors <- function(positive = "green3",
                              negative = positive,
                              true     = "green3",
                              false    = "red",
                              nan      = "purple",
                              na       = "purple",
                              inf      = "purple",
                              string   = "cyan",
                              active   = TRUE) {
  if (is.null(MODSEM_COLORS$available)) setAvailableColors()

  cols <- c(positive, negative, true, false, nan, na, inf, string)
  if (!active || any(!cols %in% MODSEM_COLORS$available)) {
    resetModsemColors()
    return(FALSE)
  }

  MODSEM_COLORS$positive <- positive
  MODSEM_COLORS$negative <- negative
  MODSEM_COLORS$true     <- true
  MODSEM_COLORS$false    <- false
  MODSEM_COLORS$nan      <- nan
  MODSEM_COLORS$na       <- na
  MODSEM_COLORS$inf      <- inf
  MODSEM_COLORS$string   <- string

  MODSEM_COLORS$f.positive <- styleOrAsIs(positive)
  MODSEM_COLORS$f.negative <- styleOrAsIs(negative)
  MODSEM_COLORS$f.true     <- styleOrAsIs(true)
  MODSEM_COLORS$f.false    <- styleOrAsIs(false)
  MODSEM_COLORS$f.nan      <- styleOrAsIs(nan)
  MODSEM_COLORS$f.na       <- styleOrAsIs(na)
  MODSEM_COLORS$f.inf      <- styleOrAsIs(inf)
  MODSEM_COLORS$f.string   <- styleOrAsIs(string)

  MODSEM_COLORS$active <- TRUE

  MODSEM_COLORS$active
}

#' Capture, colorise, and emit console text
#' @param expr Expression or object with output which should be colorized.
#' @param positive color of positive numbers.
#' @param negative color of negative numbers.
#' @param true color of \code{TRUE}.
#' @param false color of \code{FALSE}.
#' @param nan color of \code{NaN}.
#' @param na color of \code{NA}.
#' @param inf color of \code{-Inf} and \code{Inf}.
#' @param string color of quoted strings.
#' @param append String appended after the colored output (default `\\n`).
#' @param split Should output be splitted? If \code{TRUE} the output is printed 
#'  normally (in real time) with no colorization, and the colored output is printed
#'  after the code has finished executing.
#' @return Invisibly returns the *plain* captured text.
#'
#' @examples
#' set_modsem_colors(positive = "red3", 
#'                   negative = "red3",
#'                   true = "darkgreen", 
#'                   false = "red3", 
#'                   na = "purple",
#'                   string = "darkgreen")
#' 
#' m1 <- "
#' # Outer Model
#'   X =~ x1 + x2 + x3
#'   Z =~ z1 + z2 + z3
#'   Y =~ y1 + y2 + y3
#' # Inner Model
#'   Y ~ X + Z + X:Z
#' "
#' 
#' est <- modsem(m1, data = oneInt)
#' colorize_output(summary(est))
#' colorize_output(est) # same as colorize_output(print(est))
#' colorize_output(modsem_inspect(est, what = "coef"))
#'
#' \dontrun{
#' colorize_output(split = TRUE, {
#'   # Get live (uncolored) output
#'   # And print colored output at the end of execution
#' 
#'   est_lms <- modsem(m1, data = oneInt, method = "lms")
#'   summary(est_lms)
#' }) 
#'                 
#' colorize_output(modsem_inspect(est_lms))
#' }
#' @export
colorize_output <- function(expr,
                            positive = MODSEM_COLORS$positive,
                            negative = MODSEM_COLORS$negative,
                            true     = MODSEM_COLORS$true,
                            false    = MODSEM_COLORS$false,
                            nan      = MODSEM_COLORS$nan,
                            na       = MODSEM_COLORS$na,
                            inf      = MODSEM_COLORS$inf,
                            string   = MODSEM_COLORS$string,
                            split    = FALSE, 
                            append = "\n") {
  getFinalLine  <- \(x) stringr::str_split(x, pattern = "\r")
  getFinalLines <- \(x) vapply(getFinalLine(x), FUN = last,
                               FUN.VALUE = character(1L))

  lines <- captureOutput(expr, split = split)

  # Handle "\r"
  hasReplace <- grepl("\r", lines)
  lines[hasReplace] <- getFinalLines(lines[hasReplace])

  out <- stringr::str_c(lines, collapse = "\n")

  if (!MODSEM_COLORS$active) {
    cat(out, append)
    return(invisible(out))
  }

  # build mapping only for active colors
  mapping <- c()
  add <- function(pat, col) {
    if (!is.na(col)) 
      mapping <<- c(mapping, stats::setNames(getColorizedASCII(col), pat))
  }

  add(PATTERN.pos,    positive)
  add(PATTERN.neg,    negative)
  add(PATTERN.TRUE,   true)
  add(PATTERN.FALSE,  false)
  add(PATTERN.NaN,    nan)
  add(PATTERN.NA,     na)
  add(PATTERN.Inf,    inf)
  add(PATTERN.String, string)

  colored <- tryCatch(
    stringr::str_replace_all(out, mapping),
    error = function(e) {
      warning("colorization failed: ", conditionMessage(e), call. = FALSE)
      out
    }
  )

  cat(colored, append)
  invisible(out)
}
