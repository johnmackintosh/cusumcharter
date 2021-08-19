#' cusum_simple
#'
#' @param x a numeric vector from which to calculate the cumulative sum statistics
#' @param target value to compare each element of x to. If not provided, the mean of
#' x will be calculated and used as a target value
#'
#' @return a vector of the cumulative sum statistic, centred on the target value
#' @export
#'
#' @examples
#'
#' test_vec <- c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166)
#' cusum_simple(test_vec)
#'
cusum_simple <- function(x, target = NULL) {
  stopifnot(is.numeric(x) | is.double(x))

  target <-  if (is.null(target)) {target = mean(x, na.rm = TRUE)} else target
  si <- x - target
  cusumx <- cumsum(si)
  cusum_target <- cusumx + target
  return(cusum_target)

}
