#' cusum_control
#'
#' @param x  input vector
#' @param target  target value for comparison, the mean of x will be used if missing
#' @param std_dev  Defaults to the screened moving range of x.
#' A known or desired value for standard deviation can be supplied instead.
#' @param desired_shift how many standard deviations do you want to detect?
#' This value is typically between  0.5 to 1. Defaults to 1.
#' @param k allowable slack - defaults to half the standard deviation multiplied by desired shift
#' @param h action limits -  usually between 4 and 5, defaults to 4.
#' The standard deviation is multiplied by this value to determine the upper and lower limits on the chart
#'
#' @return data.frame showing original inputs and calculated control limits
#' @export
#'
#' @examples
#' test_vec3 <- c(1,1,2,3,5,7,11,7,5,7,8,9,5)
#' controls <- cusum_control(test_vec3, target = 4)
#'
#'
cusum_control <- function(x,
                          target = NULL,
                          std_dev = NULL,
                          desired_shift = 1,
                          k = 0.5,
                          h = 4) {
  stopifnot(is.numeric(x) | is.double(x) | is.integer(x))
  stopifnot(!is.na(x))
  stopifnot(is.numeric(target) | is.double(target) | is.integer(target) | is.null(target))
  stopifnot(is.numeric(desired_shift) | is.double(desired_shift) | is.integer(desired_shift))
  stopifnot(is.numeric(k) | is.double(k) | is.integer(k) | is.null(k))
  stopifnot(is.numeric(h) | is.double(h) | is.integer(h) | is.null(h))

  if (is.null(target)) {message("no target value supplied, so using the mean of x")}

  if (is.null(k)) {message("k was not supplied so using 0.5 as a default")}
  if (!is.null(k) && k > 1) {warning("k exceeds 1. It should normally be between 0.5 and 1", immediate. = TRUE)}

  if (is.null(h)) {message("h was not supplied so using 4 as a default")}
  if (!is.null(h) && h > 5) {warning("h exceeds 5. It should normally be between 4 and 5", immediate. = TRUE)}



  # functions
  positives_iterator <- function(x, pos = cplus, limit = ucl) {
    for (i in 2:length(x)) {
      pos[i] <- max(0, pos[i - 1] + x[i] - target - k)

    }
    pos

  }


  negatives_iterator <- function(x, pos = cneg, limit = lcl) {
    for (i in 2:length(x)) {
      pos[i] <- min(0, pos[i - 1] + x[i] - target + k)
    }
    pos

  }

  pos_count <- function(x) {
    ifelse(x == 0, 0, 1)
  }

  cumulatives_iterator <- function(compar_col, x) {
    x[1] <- compar_col[1]

    for (i in 2:length(compar_col)) {
      if (compar_col[i] == 0) {
        x[i] =  0
      } else {
        x[i] =  x[i - 1] + compar_col[i]
      }
    }
    x
  }



  # Variables
  target <-
    if (is.null(target)) {
      target = mean(x, na.rm = TRUE)
    } else {
      target

    }

  mr <- mean(abs(diff(x)), na.rm = TRUE)

  std_dev <- if (is.null(std_dev)) {std_dev = mr / 1.128} else std_dev

  k <- if (is.null(k)) {
    k = (0.5 * std_dev) * desired_shift
  } else {
    (std_dev * k) * desired_shift
  }

  h <- if (is.null(h)) {4} else {h}

  ucl <- target + k
  lcl <- target - k
  nrows <- NROW(x)

  # helper vectors
  cplus <- rep(0, length(x))
  cneg <- rep(0, length(x))

  # calculations

  variance <- x - target
  cusum <- cumsum(variance)

  cplus <- rep(0, length(x))
  cplus[1] <- max(0, (x[1] - ucl + 0)) #initialise first value to zero

  cneg <- rep(0, length(x))
  cneg[1] <- min(0, 0 + x[1] - target + k) #initialise first value to zero


  cplus <- positives_iterator(x = x)
  cneg <- negatives_iterator(x = x)
  nplus <- pos_count(cplus)
  nneg <- pos_count(cneg)

  cum_nplus <- rep(0, length(x))
  cum_nplus[1] <- nplus[1] # initialise first value to 1st value of nplus
  cum_nneg <- rep(0, length(x))
  cum_nneg[1] <- nneg[1] # initialise first value to 1st value of nneg

  cum_nplus <- cumulatives_iterator(compar_col = nplus, x = cum_nplus)
  cum_nneg <- cumulatives_iterator(compar_col = nneg, x = cum_nneg)


  out_df <-
    data.frame(x,
               target,
               variance,
               std_dev,
               cusum,
               cplus,
               cneg,
               cum_nplus,
               cum_nneg)

  out_df$ucl <- h * std_dev
  out_df$lcl <- (h * std_dev) * -1
  out_df$centre <- 0L
  out_df$obs <- seq(from = 1, to = nrows, by = 1)

  return(out_df)
}
