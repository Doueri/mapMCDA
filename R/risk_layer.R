#' Compute risk layer
#' 
#' Rescale a raster with a linear relationship.
#' 
#' If you need an inverse relationship, just reverse the target scale.
#'
#' @param x a RasterLayer object
#' @param boundaries a Spatial* object, used to determine the boundaries of the
#'   computed risk layer.
#' @param scale_target numeric vector of length 2. New scale.
#'
#' @return A RasterLayer object in the new scale.
#' @export
#' @import raster
#'
#' @examples
#'   ad <- mapMCDA_datasets()$animal.density
#'   bd <- mapMCDA_datasets()$cmr_admin3
#'   raster::plot(ad)
#'   raster::plot(risk_layer(ad, bd, scale_target = c(-1, 1)))
#'   raster::plot(risk_layer(ad, bd, scale_target = c(1, -1)))
risk_layer <- function(x, boundaries, scale_target = c(0, 100)) {
  
  if (inherits(x, "Spatial")) {
    r <- distance_map(x, boundaries = boundaries)
  } else {
    if (inherits(x, "RasterLayer")) {
      r <- mask(extend(crop(x, boundaries), boundaries), boundaries)
    } else {
      if (inherits(x, "igraph")) {
        r <- rasterize(x, boundaries)
      } else {
        stop("Can't compute risk layer from a ", class(x), " object.")
      }
    }
  }
  
  scale_source <- range(raster::values(r), na.rm = TRUE)
  
  if (isTRUE(all.equal(diff(scale_source), 0))) {
    stop("Risk factor ", substitute(x),
         " has a constant value and cannot be used as it is.\n",
         "Please correct or remove.")
  }
    
  ## Linear function
  lin_fun <- function(r) {
    slope <- diff(scale_target)/diff(scale_source)
    ans <- scale_target[1] + slope * (r - scale_source[1])
    return(ans)
  }
  
  ans <- calc(r, lin_fun)
  
  return(ans)
}
