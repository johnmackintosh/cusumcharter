cusum_control <- function(x,
                          target = NULL,
                          std_dev = NULL,
                          desired_shift = 1,
                          k = 0.5,
                          h = 5,
                          description = NULL){

  # Variables
  target <-  if (is.null(target)) {target = mean(x, na.rm = TRUE)} else target
  mr <- mean(abs(diff(x)), na.rm = TRUE)
  std_dev <- if (is.null(std_dev)) {std_dev = mr / 1.128} else std_dev
  k <- if (is.null(k)) {k = 0.5 * std_dev} else (std_dev * k)
  h <- if (is.null(h)) {5} else h
  description <- if (is.null(description)) {description = "cusum_control_plot"} else description

  title_text <- paste0("CuSum of ", description)

  ucl <- target + k
  lcl <- target - k
  nrows <- NROW(x)

  # helper vectors
  cplus <- rep(0,length(x))
  cneg <- rep(0,length(x))

  # functions
  positives_iterator <- function(x, pos = cplus, limit = ucl) {


    for (i in 2:length(x)) {
      pos[i] <- max(0,(x[i] - limit + pos[i - 1] ))
    }
    pos

  }


  negatives_iterator <- function(x, pos = cneg, limit = lcl) {


    for (i in 2:length(x)) {
      pos[i] <-  max(0,(limit - x[i] + pos[i - 1]))
    }
    pos

  }

  pos_count <- function(x) {
    ifelse(x == 0,0,1)
  }

  cumulatives_iterator <- function(compar_col,x) {

    x[1] <- compar_col[1]

    for (i in 2:length(compar_col)) {
      if (compar_col[i] == 0){
        x[i] =  0
      } else {
        x[i] =  x[i - 1] + compar_col[i]
      }
    }
    x
  }



  # calcs

  variance <- x - target
  cusum <- cumsum(variance)

  x_ucl <- x - ucl
  cplus <- rep(0,length(x))
  cplus[1] <- max(0,(x[1] - ucl[1] + 0))
  x_lcl <- lcl - x
  cneg <- rep(0,length(x))
  cneg[1] <- max(0,(lcl - x[1] + 0))

  cplus <- positives_iterator(x = x)
  cneg <- negatives_iterator(x = x)
  nplus <- pos_count(cplus)
  nneg <- pos_count(cneg)

  cum_nplus <- rep(0,length(x))
  cum_nplus[1] <- nplus[1]
  cum_nneg <- rep(0,length(x))
  cum_nneg[1] <- nneg[1]

  cum_nplus <- cumulatives_iterator(compar_col = nplus, x = cum_nplus)
  cum_nneg <- cumulatives_iterator(compar_col = nneg, x = cum_nneg)
  cum_nneg <- cum_nneg * -1
  cneg <- cneg * -1


  out_df <- data.frame(x,target, variance,cusum,cplus,cum_nplus,cneg,cum_nneg)
  out_df$ucl <- h
  out_df$lcl <- h*-1
  out_df$centre <- 0L
  out_df$obs <- seq(from = 1, to = nrows, by = 1)
  return(out_df)
}

cusum_control_plot <- function(df, title_text = NULL) {

  p <- ggplot2::ggplot(df,ggplot2::aes(x = .data$obs, y = .data$cplus, group = 1)) +
    ggplot2::geom_line(colour = "#000099") +
    ggplot2::geom_point(colour = "#000099")

  p <- p + ggplot2::geom_line(aes(.data$obs, .data$cneg))
  p <- p + ggplot2::geom_point(aes(.data$obs, .data$cneg))
  p <- p + ggplot2::geom_line(aes(.data$obs, .data$ucl),colour = "red")
  p <- p + ggplot2::geom_line(aes(.data$obs, .data$lcl),colour = "red")
  p <- p + ggplot2::geom_line(aes(.data$obs, .data$centre), colour = "grey50")
  p <- p + ggplot2::theme_minimal()
  p <- p + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  p <- p + ggplot2::labs(title = title_text)
  p
}
