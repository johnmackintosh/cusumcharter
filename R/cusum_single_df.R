#' cusum_single_df
#'
#' @param x a numeric vector from which to calculate the cumulative sum statistics
#' @param target value to compare each element of x to. If not provided, the mean of
#' x will be calculated and used as a target value
#'
#' @return a dataframe with the original values, target, the variance, the cumulative sum of the variance, and the cumulative sum centered on the target value. This centering is achieved by adding the target value to the cumulative sum.
#' @export
#'
#' @examples
#'
#' test_vec <- c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166)
#' cusum_single_df(test_vec, target = 0.16)
#'
#'
cusum_single_df <- function(x, target = NULL) {
  stopifnot(is.numeric(x) | is.double(x) | is.integer(x))
  stopifnot(!is.na(x))
  stopifnot(is.numeric(target) | is.double(target) | is.integer(target) | is.null(target))

  target <-  if (is.null(target)) {target = mean(x, na.rm = TRUE)} else target
  si <- x - target
  cusumx <- cumsum(si)
  cusum_target <- cusumx + target

  out_df <- data.frame(x, target, si,cusumx,cusum_target)
  return(out_df)

}
