test_that("cusum_control_median works", {

  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)

  x <-  c(1,1,2,11,3,5,7,2,4,3,5)
  target <- c(3,3,3,3,3,3,3,3,3,3,3)
  variance <- c(-2, -2, -1, 8,0,2,4,-1,1,0,2)
  std_dev <- c(2.8368794, 2.8368794, 2.8368794, 2.8368794, 2.8368794, 2.8368794,
                2.8368794, 2.8368794, 2.8368794, 2.8368794, 2.8368794)
  cusum <- c(-2, -4, -5,  3,  3,  5,  9,  8,  9,  9, 11)
  cplus <- c(0, 0, 0, 6.58156028, 5.16312057, 5.74468085, 8.32624113, 5.90780142,
             5.48936170, 4.07092199, 4.652482)
  cneg <- c(-0.58156028, -1.16312057, -0.74468085, 0, 0,  0, 0, 0,  0, 0,0)
  cum_nplus <- c(0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8)
  cum_nneg <- c(1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0)
  ucl <- rep(11.34752,11)
  ucl <- round(ucl,3)
  lcl <- rep(-11.34752,11)
  lcl <- round(lcl,3)
  centre <- 0
  obs <- 1:11
  output <- data.frame(x, target, variance,std_dev, cusum, cplus, cneg,
                       cum_nplus,cum_nneg,ucl,lcl,centre,obs)

  res <- cusum_control_median(test_vec)
  res$ucl <- round(res$ucl,3)
  res$lcl <- round(res$lcl,3)


  expect_equal(output, res)
})


test_that("non numeric vector fails", {

  test_vec3 <- as.character(c(1,1,2,11,3,5,7,2,4,3,5))
  expect_error(cusum_control_median(test_vec3, target = 5))
})

test_that("na elements fail", {

  test_vec3 <- c(0.175, NA, 0.15, 0.207, 0.136, NA, 0.166)
  expect_error(cusum_control_median(test_vec3, target = 0.16))
})

test_that("high k generates warning",{
  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)
  expect_warning(cusum_control_median(test_vec,k = 2))
})

test_that("high h generates warning",{
  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)
  expect_warning(cusum_control_median(test_vec, h = 6))
})


test_that("k = NULL generates message", {
  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)
  expect_message(cusum_control_median(test_vec,
                               target = 4,
                               k = NULL,
                               h = 5),
                 "k was not supplied so using 0.5 as a default")
})

test_that("h = NULL generates message", {
  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)
  expect_message(cusum_control_median(test_vec,
                               target = 4,
                               k = 1,
                               h = NULL),
                 "h was not supplied so using 4 as a default")
})


test_that("target value propagates", {
  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)
  target1 <- rep(6,11)
  res <- cusum_control_median(test_vec,target = 6)

  expect_equal(target1,res$target)

})
