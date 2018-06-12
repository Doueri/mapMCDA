context("Transformation of original scales to risk scale")

cmr <- mapMCDA_datasets()

test_that("risk re-scaling of a raster", {
  
  # dist_wb <- distance_map(cmr$water_bodies, cmr$cmr_admin3)
  # raster::plot(dist_wb)
  
  st <- c(-7, 33)
  risk_ad <- risk_layer(cmr$animal.density, scale_target = st)
  risk_da <- risk_layer(cmr$animal.density, scale_target = rev(st))  # Inverse scale!!
  # raster::plot(risk_ad)
  # raster::plot(risk_da)
  
  ## The direct risk value in a cell of max/min distance is the largest/smallest
  expect_identical(unname(risk_ad[which.max(raster::getValues(cmr$animal.density))]), st[2])
  expect_identical(unname(risk_ad[which.min(raster::getValues(cmr$animal.density))]), st[1])

  ## The inverse risk value in a cell of max/min distance is the smallest/largest
  expect_identical(unname(risk_da[which.max(raster::getValues(cmr$animal.density))]), st[1])
  expect_identical(unname(risk_da[which.min(raster::getValues(cmr$animal.density))]), st[2])
})


test_that("risk map from vector: compute distances", {

  st <- c(0, 100)
  expect_error(
    risk_layer(cmr$water_bodies, boundaries = cmr$cmr_admin3, scale_target = st),
    NA  # Expects no error
  )
  
})

test_that("risk map from larger raster: crop to boundaries", {
  #TODO
})