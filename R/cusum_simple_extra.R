cusum_simple_extra <- function(x, target = NULL) {
  stopifnot(is.numeric(x) | is.double(x))

  target <-  if (is.null(target)) {target = mean(x, na.rm = TRUE)} else target
  si <- x - target
  cusumx <- cumsum(si)
  cusum_target <- cusumx + target

  out_df <- cbind(x, target, si,cusumx,cusum_target)
  return(out_df)

}
