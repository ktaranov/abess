library(abess)
library(testthat)

test_that("generic (univariate) works", {
  n <- 60
  p <- 60
  support_size <- 3
  
  dataset <- generate.data(n, p, support_size, seed = 1)
  abess_fit <- abess(dataset[["x"]], dataset[["y"]])
  
  expect_invisible(print(abess_fit))
  
  expect_invisible(plot(abess_fit))
  expect_invisible(plot(abess_fit, type = "l2norm"))
  expect_invisible(plot(abess_fit, type = "dev"))
  expect_invisible(plot(abess_fit, type = "tune"))
  
  expect_visible(coef(abess_fit))
  expect_visible(coef(abess_fit, support.size = 2))
  expect_visible(coef(abess_fit, sparse = FALSE))
  
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,]))
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,], support.size = c(3, 4)))
  
  expect_visible(extract(abess_fit))
  expect_visible(extract(abess_fit, support.size = 4))
  
  expect_visible(deviance(abess_fit))
  expect_visible(deviance(abess_fit, type = "gic"))
  expect_visible(deviance(abess_fit, type = "aic"))
  expect_visible(deviance(abess_fit, type = "bic"))
  expect_visible(deviance(abess_fit, type = "ebic"))
  
  abess_fit <-
    abess(dataset[["x"]], dataset[["y"]], tune.type = "gic")
  expect_visible(deviance(abess_fit, type = "gic"))
  
  ## binomial
  dataset <-
    generate.data(n, p, support_size, seed = 1, family = "binomial")
  abess_fit <-
    abess(dataset[["x"]], dataset[["y"]], family = "binomial")
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,]))
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,], type = "response"))
  
  ## poisson
  dataset <-
    generate.data(n, p, support_size, seed = 1, family = "poisson")
  abess_fit <-
    abess(dataset[["x"]], dataset[["y"]], family = "poisson")
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,]))
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,], type = "response"))
  
  ## cox
  dataset <-
    generate.data(n, p, support_size, seed = 1, family = "cox")
  abess_fit <- abess(dataset[["x"]], dataset[["y"]], family = "cox")
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,]))
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,], type = "response"))
})


test_that("generic (multivariate) works", {
  n <- 60
  p <- 60
  support_size <- 3
  
  dataset <-
    generate.data(n, p, support_size, seed = 1, family = "mgaussian")
  abess_fit <- abess(dataset[["x"]], dataset[["y"]],
                     family = "mgaussian", tune.type = "gic")
  
  expect_invisible(print(abess_fit))
  
  expect_invisible(plot(abess_fit))
  expect_invisible(plot(abess_fit, type = "l2norm"))
  expect_invisible(plot(abess_fit, type = "dev"))
  expect_invisible(plot(abess_fit, type = "tune"))
  
  expect_visible(coef(abess_fit))
  expect_visible(coef(abess_fit, support.size = 2))
  expect_visible(coef(abess_fit, sparse = FALSE))
  
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,]))
  expect_visible(predict(abess_fit,
                         newx = dataset[["x"]][1:10,],
                         support.size = c(3, 4)))
  
  expect_visible(extract(abess_fit))
  expect_visible(extract(abess_fit, support.size = 4))
  
  expect_visible(deviance(abess_fit))
  expect_visible(deviance(abess_fit, type = "gic"))
  expect_visible(deviance(abess_fit, type = "aic"))
  expect_visible(deviance(abess_fit, type = "bic"))
  expect_visible(deviance(abess_fit, type = "ebic"))
  
  ## multinomial
  dataset <-
    generate.data(n, p, support_size, seed = 1, family = "multinomial")
  abess_fit <-
    abess(dataset[["x"]], dataset[["y"]], family = "multinomial")
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,]))
  expect_visible(predict(abess_fit, newx = dataset[["x"]][1:10,], type = "response"))
})


test_that("generic (abesspca) works", {
  n <- 60
  p <- 60
  support_size <- 3
  
  ## F-PCA
  dataset <- generate.data(n, p, support_size, seed = 1)
  abess_fit <- abesspca(dataset[["x"]])
  
  expect_invisible(print(abess_fit))
  
  # expect_invisible(plot(abess_fit))
  # expect_invisible(plot(abess_fit, type = "variance"))
  
  expect_visible(coef(abess_fit))
  expect_visible(coef(abess_fit, support.size = 3))
  expect_visible(coef(abess_fit, sparse = FALSE))
  
  ## K-PCA
  abess_fit <- abesspca(dataset[["x"]],
                        sparse.type = "kpc",
                        support.size = c(1, 1, 1))
  
  expect_invisible(print(abess_fit))
  
  # expect_invisible(plot(abess_fit))
  # expect_invisible(plot(abess_fit, type = "variance"))
  
  expect_visible(coef(abess_fit))
  expect_visible(coef(abess_fit, kpc = 2))
  expect_visible(coef(abess_fit, sparse = FALSE))
})

### As a by-production, testing data.generator:
test_that("data generator works", {
  n <- 50
  p <- 50
  support_size <- 3
  
  expect_visible(generate.data(n, p, support_size, seed = 1, cortype = 2))
  expect_visible(generate.data(n, p, support_size, seed = 1, cortype = 3))
  
  expect_visible(generate.data(
    n,
    p,
    seed = 1,
    family = "gaussian",
    beta = c(rep(1, 5), rep(0, p - 5))
  ))
  expect_visible(generate.data(
    n,
    p,
    seed = 1,
    family = "binomial",
    beta = c(rep(1, 5), rep(0, p - 5))
  ))
  expect_visible(generate.data(
    n,
    p,
    seed = 1,
    family = "poisson",
    beta = c(rep(1, 5), rep(0, p - 5))
  ))
  expect_visible(generate.data(
    n,
    p,
    seed = 1,
    family = "cox",
    beta = c(rep(1, 5), rep(0, p - 5))
  ))
  expect_visible(generate.data(
    n,
    p,
    seed = 1,
    family = "mgaussian",
    beta = matrix(rep(c(
      rep(1, 5), rep(0, p - 5)
    ), 3),
    ncol = 3)
  ))
  expect_visible(generate.data(
    n,
    p,
    seed = 1,
    family = "multinomial",
    beta = matrix(rep(c(
      rep(1, 5), rep(0, p - 5)
    ), 3),
    ncol = 3)
  ))
})
