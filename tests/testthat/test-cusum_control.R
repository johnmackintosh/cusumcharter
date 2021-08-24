test_that("cusum_single_df works", {

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


  expect_equal(output, res)
})


test_that("non numeric vector fails", {

  test_vec3 <- as.character(c(1,1,2,11,3,5,7,2,4,3,5))
  expect_error(cusum_control(test_vec3, target = 5))
})

test_that("na elements fail", {

  test_vec3 <- c(0.175, NA, 0.15, 0.207, 0.136, NA, 0.166)
  expect_error(cusum_control(test_vec3, target = 0.16))
})
