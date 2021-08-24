test_that("cusum_single works", {

  test_vec <- c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166)
  expected_res <- c(0.1750000, 0.1558571, 0.1347143, 0.1705714,
                    0.1354286, 0.1762857, 0.1711429)

  expected_res <- round(expected_res,6)
  func_res <- cusum_single(test_vec)
  func_res <- round(func_res,6)

  expect_equal(func_res, expected_res)
})

test_that("target replaces mean and gives expected results", {

  test_vec2 <- c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166)
  expected_res2 <- c(0.175, 0.167, 0.157, 0.204, 0.180, 0.232, 0.238)
  func_res2 <- cusum_single(test_vec2, target = 0.16)
  expect_equal(func_res2, expected_res2)

})


test_that("non numeric vector fails", {

  test_vec3 <- as.character(c(0.175, 0.152, 0.15, 0.207, 0.136, 0.212, 0.166))
  expect_error(cusum_single(test_vec3, target = 0.16))
})


test_that("na elements fail", {

  test_vec3 <- c(0.175, NA, 0.15, 0.207, 0.136, NA, 0.166)
  expect_error(cusum_single(test_vec3, target = 0.16))
})
