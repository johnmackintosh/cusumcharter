test_that("cusum_single_df works", {

  test_vec <- c(1,1,2,11,3,5,7,2,4,3,5)
  x <-  c(1,1,2,11,3,5,7,2,4,3,5)
  target <- c(3,3,3,3,3,3,3,3,3,3,3)
  si <- c(-2,-2,-1,8,0,2,4,-1,1,0,2)
  cusumx <- c(-2,-4,-5,3,3,5,9,8,9,9,11)
  cusum_target <- c(1,-1,-2,6,6,8,12,11,12,12,14)

  output <- data.frame(x, target, si,cusumx,cusum_target)

  res <- cusum_single_median_df(test_vec)


  expect_equal(output, res)
})


test_that("target replaces mean and gives expected results in output df", {

  test_vec2 <- c(1,1,2,11,3,5,7,2,4,3,5)
  x <-  c(1,1,2,11,3,5,7,2,4,3,5)
  target <- c(5,5,5,5,5,5,5,5,5,5,5)
  si <- c(-4,-4,-3,6,-2,0,2,-3,-1,-2,0)
  cusumx <- c(-4,-8,-11,-5,-7,-7,-5,-8,-9,-11,-11)
  cusum_target <- c(1,-3,-6,0,-2,-2,0,-3,-4,-6,-6)

  output2 <- data.frame(x, target, si,cusumx,cusum_target)
  res2 <- cusum_single_median_df(test_vec2, target = 5)
  expect_equal(output2, res2)

})


test_that("non numeric vector fails", {

  test_vec3 <- as.character(c(1,1,2,11,3,5,7,2,4,3,5))
  expect_error(cusum_single_median_df(test_vec3, target = 5))
})

test_that("na elements fail", {

  test_vec3 <- c(0.175, NA, 0.15, 0.207, 0.136, NA, 0.166)
  expect_error(cusum_single_median_df(test_vec3))
})
