% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mapMCDA_datasets.R
\name{mapMCDA_datasets}
\alias{mapMCDA_datasets}
\title{Load packaged Cameroon layers into memory}
\usage{
mapMCDA_datasets()
}
\value{
list of spatial layers
}
\description{
Loads a list of 4 geographical layers of Cameroon. Namely: the raster of
animal density, the administrative borders at the third level, the national
parks and the water bodies.
}
\details{
Sources are the Gridded Livestock of the World database (ref?), the Global
Administrative Boundaries database (gadm.org), and ???.
}
\examples{
  cmr <- mapMCDA_datasets()
}
