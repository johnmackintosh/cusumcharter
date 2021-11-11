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

p <- cusum_control_plot(controls, xvar = obs,
                        title_text = "CUSUM shows out of control since 7th observation")

p_output <- p$data
p_output$ucl <- round(p_output$ucl,3)
p_output$lcl <- round(p_output$lcl,3)

expect_equal(p_output,res)

}
)


test_that("facets work", {
  library(data.table)
  library(cusumcharter)

  testdata <- data.frame(
    stringsAsFactors = FALSE,
    N = c(1L,2L,1L,3L,1L,1L,1L,1L,1L,
          2L,1L,1L,1L,10L,7L,2L,3L,5L),
    metric = c("metric1","metric1","metric1","metric1","metric1",
               "metric1","metric1","metric1","metric1","metric2",
               "metric2","metric2","metric2","metric2","metric2",
               "metric2","metric2","metric2"))

  testlist <- split(testdata$N,testdata$metric)

  testres <- lapply(testlist, cusumcharter::cusum_control)

  testres <- data.table::rbindlist(testres,fill = TRUE, idcol = TRUE)

  p <- cusum_control_plot(testres, xvar = obs, facet_var = .id, title_text = " faceted CUSUM Control plots")

  expect_equal(p$facet$vars(),".id")

})


test_that("date facets work", {
  library(data.table)
  library(cusumcharter)

  testdata <- data.frame(
    stringsAsFactors = FALSE,
    N = c(1L,2L,1L,3L,1L,1L,1L,1L,1L,
          2L,1L,1L,1L,10L,7L,2L,3L,5L),
    metric = c("metric1","metric1","metric1","metric1","metric1",
               "metric1","metric1","metric1","metric1","metric2",
               "metric2","metric2","metric2","metric2","metric2",
               "metric2","metric2","metric2"))

  testlist <- split(testdata$N,testdata$metric)

  testres <- lapply(testlist, cusumcharter::cusum_control)

  testres <- data.table::rbindlist(testres,fill = TRUE, idcol = TRUE)

  testres[, datecol := c("2021-01-01","2021-01-02", "2021-01-03",
                         "2021-01-04" ,"2021-01-05", "2021-01-06",
                         "2021-01-07", "2021-01-08", "2021-01-09"), by = .id]

  testres[,datecol := as.Date(datecol)]

  p2 <- cusum_control_plot(testres, xvar = datecol,
                           facet_var = .id,
                           title_text = " faceted plots with date axis",
                           scale_type = "date",
                           datebreaks = '2 days')



  expect_equal(p2$data$datecol,testres$datecol)

})



test_that("datetime facets work", {
  library(data.table)
  library(cusumcharter)

  testdata <- data.frame(
    stringsAsFactors = FALSE,
    N = c(1L,2L,1L,3L,1L,1L,1L,1L,1L,
          2L,1L,1L,1L,10L,7L,2L,3L,5L),
    metric = c("metric1","metric1","metric1","metric1","metric1",
               "metric1","metric1","metric1","metric1","metric2",
               "metric2","metric2","metric2","metric2","metric2",
               "metric2","metric2","metric2"))

  testlist <- split(testdata$N,testdata$metric)

  testres <- lapply(testlist, cusumcharter::cusum_control)

  testres <- data.table::rbindlist(testres,fill = TRUE, idcol = TRUE)


  testres[, datetimecol := c("2021-09-03 22:19:46", "2021-09-03 22:20:46","2021-09-03 22:21:46", "2021-09-03 22:22:46", "2021-09-03 22:23:46", "2021-09-03 22:24:46" , "2021-09-03 22:25:46", "2021-09-03 22:26:46", "2021-09-03 22:27:46"), by = .id]

  testres[,datetimecol := as.POSIXct(datetimecol)]

  p3 <- cusum_control_plot(testres, xvar = datetimecol,
                           facet_var = .id,
                           title_text = " faceted plots with datetime axis",
                           scale_type = "datetime",
                           datebreaks = '2 mins')



  expect_equal(p3$data$datetimecol,testres$datetimecol)

})




test_that("above ucl points plot", {
  library(data.table)
  library(cusumcharter)

  testdata <- data.frame(
    stringsAsFactors = FALSE,
    N = c(1L,2L,1L,3L,1L,1L,1L,1L,1L,
          2L,1L,1L,1L,10L,7L,9L,11L,9L),
    metric = c("metric1","metric1","metric1","metric1","metric1",
               "metric1","metric1","metric1","metric1","metric2",
               "metric2","metric2","metric2","metric2","metric2",
               "metric2","metric2","metric2"))

  testlist <- split(testdata$N,testdata$metric)

  testres <- lapply(testlist, cusumcharter::cusum_control)

  testres <- data.table::rbindlist(testres,fill = TRUE, idcol = TRUE)

  p4 <- cusum_control_plot(testres,
                           xvar = obs,
                           facet_var = .id,
                           title_text = " Faceted CUSUM Control plots")

  expect_equal(dim(p4$layers[[4]]$data)[1],2)

  mylist <- list(colour = "#c9052c")

  expect_equal(p4$layers[[4]]$aes_params,mylist) # layer 4 is above ucl

})



test_that("below ucl points plot", {
  library(data.table)
  library(cusumcharter)

testdata <- data.frame(
stringsAsFactors = FALSE,
N = c(-15L,2L,-11L,3L,1L,1L,-11L,1L,1L,
2L,1L,1L,1L,10L,7L,9L,11L,9L),
metric = c("metric1","metric1","metric1","metric1","metric1",
"metric1","metric1","metric1","metric1","metric2",
"metric2","metric2","metric2","metric2","metric2",
"metric2","metric2","metric2"))
testlist <- split(testdata$N,testdata$metric)
testres <- lapply(testlist, cusumcharter::cusum_control)
testres <- data.table::rbindlist(testres,fill = TRUE, idcol = TRUE)

p5 <- cusum_control_plot(testres,
                         xvar = obs,
                         show_below = TRUE,
                         facet_var = .id,
                         title_text = " Faceted CUSUM Control plots")

expect_equal(dim(p5$layers[[4]]$data)[1],2)

mylist <- list(colour = "#c9052c")

expect_equal(p5$layers[[7]]$aes_params,mylist) #cneg out of bounds is 7th layer

})
