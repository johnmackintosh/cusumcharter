test_that("plots have known output", {
  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)

  x <-  c(1,1,2,11,3,5,7,2,4,3,5)
  target <- c(4,4,4,4,4,4,4,4,4,4,4)
  variance <- c(-3,-3,-2,7,-1,1,3,-2,0,-1,1)
  std_dev <- c( 2.8368794, 2.8368794, 2.8368794, 2.8368794, 2.8368794, 2.8368794,
                2.8368794, 2.8368794, 2.8368794, 2.8368794, 2.8368794)
  cusum <- c(-3,-6,-8,-1,-2,-1,2,0,0,-1,0)
  cplus <- c(0, 0, 0, 5.5815603, 3.1631206, 2.7446809, 4.3262411, 0.9078014,
             0, 0, 0)
  cneg <- c(-1.5815603, -3.1631206, -3.7446809, 0, 0,  0, 0, -0.5815603,  0, 0,0)
  cum_nplus <- c(0, 0, 0, 1, 2, 3, 4, 5, 0, 0, 0)
  cum_nneg <- c(1, 2, 3, 0, 0, 0, 0, 1, 0, 0, 0)
  ucl <- rep(11.348,11)
  lcl <- rep(-11.348,11)
  centre <- 0
  obs <- 1:11
  output <- data.frame(x, target, variance,std_dev, cusum, cplus, cneg,
                       cum_nplus,cum_nneg,ucl,lcl,centre,obs)

  res <- cusum_control(test_vec)
  res$ucl <- round(res$ucl,3)
  res$lcl <- round(res$lcl,3)

  controls <- cusum_control(test_vec)

p <- cusum_control_plot(controls, do_facet = FALSE, title_text = "sample CuSum with controls shows out of control since 7th observation")

p_output <- p$data
p_output$ucl <- round(p_output$ucl,3)
p_output$lcl <- round(p_output$lcl,3)

expect_equal(p_output,res)

}
)

