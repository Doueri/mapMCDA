context("weights")

test_that("compute weights", {
  x <- matrix(1, 10, 10)
  expect_equal(
    compute_weights(x),
    rep(1/nrow(x), nrow(x))
  )
  
  x <- matrix(1, 1, 1)
  expect_identical(
    compute_weights(x),
    1
  )
  
  x <- matrix(1:9, 3, 3)
  expect_error(
    compute_weights(x),
    "not TRUE"
  )

  ## example from Malczewski 1999, p. 183
  ## not consistent with the eigenvector algorithm, but approximate
  x <- diag(3)  
  x[upper.tri(x)] <- c(4, 7, 5)
  x[lower.tri(x)] <- 1/c(4, 7, 5)
  exp_w <- c(0.675, 0.252, 0.073)
  expect_equal(compute_weights(x), exp_w, tol = .02)
  
  ## example from Saaty 1987, p. 165
  ## eigenvector?
  ## Not consistent with any of the algorithms
  x <- diag(4)
  x[upper.tri(x)] <- c(1/7, 1/5, 2, 1/5, 3, 1)
  x[lower.tri(x)] <- 1/x[upper.tri(x)]
  exp_w <- c(0.053, 0.491, 0.238, 0.213)
  # expect_equal(compute_weights(x), exp_w, tol = .001)

})


test_that("is.reciprocal() works as expected", {

  # Non-reciprocal matrix  
  Xf <- matrix(1:16, 4, 4)
  
  # Reciprocal matrix
  Xr <- Xf
  Xr[upper.tri(Xf)] <- 1/t(Xf)[upper.tri(Xf)]
  diag(Xr) <- 1
  
  expect_false(is.reciprocal(Xf))
  expect_true(is.reciprocal(Xr))

  ## -1 is also a valid value in the diagonal
  ## and negative values are also valid as long as they are reciprocal
  expect_true(is.reciprocal(replace(Xr, 1, -1)))
  expect_true(is.reciprocal(replace(Xr, c(2, 5), c(-2, -1/2))))
  
  ## Single numbers are reciprocal if 1 or -1
  expect_true(is.reciprocal(1))
  expect_true(is.reciprocal(-1))
  expect_false(is.reciprocal(2))
})