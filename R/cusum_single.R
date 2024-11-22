#' Calculates the cumulative sum statistic relative to target, or mean value
#'
#' Calculates the cumulative sum statistic of a vector of values, centred on either the mean of the data, or a supplied target value.
#'
#' \code{cusum_vec} is an alias and works the same way.
#'
#' @param x a numeric vector from which to calculate the cumulative sum statistics
#' @param target value to compare each element of x to. If not provided, the target will be calculated using the fun argument
#'
#' @param FUN either mean, or median, used to calculate a target value if none is supplied
#'
#' @return a vector of the cumulative sum statistic, centred on the target value
#' @export
#'
#' @examples
#'
#'
#' test_vec <- c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166)
#' cusum_single(test_vec)
#'
cusum_single <- function(x, target = NULL, FUN = "mean") {

  if (as.character(match.call()[[1]]) == "cusum_single") {
    warning("cusum_single will be deprecated in future versions.\nPlease use cusum_vec() instead of cusum_single()", call. = FALSE)
  }

  stopifnot(is.numeric(x))
  stopifnot(!any(is.na(x)))
  stopifnot(is.null(target) | is.numeric(target))

  target <- if (is.null(target)) {
    fun <- match.fun(FUN)
    target <- fun(x, na.rm = TRUE)
  } else {
    target
  }

  si <- x - target
  cusumx <- cumsum(si)
  cusum_target <- cusumx + target
  return(cusum_target)
}

#' @rdname cusum_single
#'
#' @examples
#' test_vec <- c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166)
#' cusum_vec(test_vec)
#'
#' @export
cusum_vec <- cusum_single
