################### PURPOSE OF THE APP ###################
#Interface for PRODEL project
#May 2018, by Sylvain Falala, Unit CIRAD-INRA ASTRE

################### LIBRARIES ################### 
library(stringr) # to work with character strings
library(rgdal) #to work with spatial vector
library(raster) #to work with spatial raster

library(shiny)
library(shinydashboard) # to create dashboard
library(rhandsontable) # editable table

wImage <- 1024
hImage <- 768

appTitle <- "MapMCDA"

vectorExt <- c("shp", "gpkg")

rasterExt <- c("tif", "tiff")

mobExt <- "csv"

acceptLayerType <- paste0(".", c(vectorExt, rasterExt))

reExt <- "\\.\\w{1,}$" # regular expression to define file extension

# 1 layer in global environment is a list with :
# 1: raw layer
# 2: scale target
# 3: standardized layer
indRawLay <- 1
indScale <- 2
indStandLay <- 3
nbLayIndex <- 3


preloadPath <- "preload"

vectNames <- c("name", "size", "type", "datapath", "layerType", "shortName", "originalName", "adminUnit")

glUploadFileDF <- NULL
glLayerDF <- NULL
glWeightMatrix <- NULL

# Columns to retrieve in data frame of layers for editable table
toEditLayerColNames <- c("originalName", "shortName", "layerType", "adminUnit")

# Column names for editable table of layers
langLayerList <- list(c("Name_orig", "Name_new", "Type", "Admin_unit"), 
                      c("Nom_orig", "Nom_modif", "Type", "Unite_admin"))

# Columns read only in editable table of layers
lockOrigNameCol <- 1
lockTypeCol <- 3

# Columns editable in editable table of layers
newNameCol <- 2
newAdminCol <- 4


#### LANGUAGE ####

# Language to use: 1 = english, 2 = french
indLang <- 1

#languages <- c("English" = "1", "Francais" = "2")

# Fichiers
langMenuFile <- c("Files","Fichiers")

langBoxFile <- langMenuFile

langFileList <- c("Names","Noms")

langBoxLayer <- c("Layers", "Couches")

langHelpFiles <- c(
  "Import files, including a vector map with epidemiological units.",
  "Importer fichiers, y-compris une carte vectorielle avec des unités épidémiologiques."
)

langHelpLayers <- c(
  "Check the epidemiological units layer.",
  "Signaler la couche d'unités épidémiologiques."
)

langHelpScale <- c(
  "Harmonise the original scales into a common risk-scale. Use the button to reverse the relationship.",
  "Harmoniser les échelles originales en une échelle de risque commune. Utiliser le bouton pour inverser la relation."
)

langHelpMatrix <- c(
  "The factor in row i is x[i,j] times more important than the factor in column j.",
  "Le facteur de la ligne i est x[i, j] fois plus important que le facteur de la colonne j."
)


# Epidemiological unit
langMenuUnit <- c("Epidemiological units","Unit&#233;s &#233;pid&#233;miologiques")

langBoxUnitMap <- c("Map", "Carte")

langBoxUnitStat <- c("Statistics", "Statistiques")


# Risk factors
langMenuRisk <- c("Risk factors","Facteurs de risque")

langBoxRiskRawMap <- c("Original scale", "Échelle originale")

langBoxRiskStandRaster <- c("Risk scale", "Échelle de risque")

langRBRiskLayer <- c("Scale risk factors",
                     "Mise en échelle des facteurs de risque")

langABRiskRasterInvert <- c("Invert", "Inverser")




# Weight
langMenuWeight <- c("Weight","Poids")

langBoxWeightMatrix <- c("Pairwise comparison Matrix", "Matrice de comparaison par paires")

langBoxWeightBar <- c("Weights histogram", "Histogramme des poids")

# Results
langMenuResult <- c("Results","R&#233;sultats")

langAdminUnitResult <- c("Per Epidemiological unit","Par unité épidémiologique ")

langLevelResult <- c("Risk level:", "Niveau de risque :")



# Type of layer
lVect <- c("Vector","Vecteur")

lRast <- c("Raster","Raster")

lMob <- c("MobGraph","MobGraph")


langTitleFileInput <- c("Select layers",
                        "S&#233;lectionnez les fichiers de vecteurs - rasters - mobilite")

langButtonFileInput <- list(c("Browse...", "No file selected"), 
                            c("Parcourir...", "Pas de selection"))


langLayerRemove <- c("Remove", "Supprimer")


################### MAIN PROGRAM ###################

#List preload files
outbFiles <- list.files(path = preloadPath)

if(!is.na(outbFiles[1])){
  
  nbFiles <- length(outbFiles)
  
  glLayerDF <- data.frame(matrix(nrow = nbFiles, ncol = length(vectNames)), stringsAsFactors = FALSE)
  
  colnames(glLayerDF) <- vectNames
  
  glLayerDF$name <- outbFiles
  
  glLayerDF$datapath <- paste(preloadPath, outbFiles, sep = "/")
  
  glUploadFileDF <- subset(glLayerDF, select = c("name", "size", "type", "datapath"))
  
  
  # Retrieve file extension to define type of layer: vector or raster
  fileExt <- str_extract(glLayerDF$name, reExt)
  fileExt <- tolower(str_replace(fileExt, "\\.", ""))
  
  glLayerDF$layerType <- rep("Unknown", nbFiles)
  
  indVect <- which(fileExt %in% vectorExt)
  if(!is.na(indVect[1])) glLayerDF[indVect,"layerType"] <- lVect[indLang]
  
  indRast <- which(fileExt %in% rasterExt)
  if(!is.na(indRast[1])) glLayerDF[indRast,"layerType"] <- lRast[indLang]
  
  indMob <- which(fileExt %in% mobExt)
  if(!is.na(indMob[1])) layerFiles[indMob,"layerType"] <- lMob[indLang]
  
  #Remove unknown file type
  indRem <- which(glLayerDF$layerType=="Unknown")
  if(!is.na(indRem[1])) glLayerDF <- glLayerDF[-indRem,]
  
  
  
  # Create short name for the layer based on the file name
  # Remove file extension
  glLayerDF$shortName <- gsub(reExt, "", glLayerDF$name, ignore.case = TRUE, perl = TRUE)
  
  # Remove special characters
  glLayerDF$shortName <- iconv(glLayerDF$shortName, from = "UTF-8", to = "ASCII", sub = "")
  
  # Remove blanks  
  glLayerDF$shortName <- gsub("\\s+", "", glLayerDF$shortName, ignore.case = TRUE, perl = TRUE)
  
  glLayerDF$originalName <- glLayerDF$shortName
  
  nbLayer <- nrow(glLayerDF)
  layerNames <- sort(glLayerDF$shortName)
  
  # If layer is administrative units
  glLayerDF$adminUnit <- rep(FALSE, nbLayer)
  
  
  
  # Load in global environment
  for(k in 1:nbLayer){
    
    #If vector
    if(glLayerDF[k,"layerType"]==lVect[indLang]){
      
      # If shape file
      if(str_detect(glLayerDF[k,"name"], ".shp")){
        
        # Retrieve path of shp file to define dsn
        shpDir <- gsub(paste("/", glLayerDF[k,"name"], sep = ""),"", glLayerDF[k,"datapath"])
        
        # Extract shp file name without extension to define layer name
        shpLayer <- gsub(".shp","", glLayerDF[k,"name"])
      }
      
      # If geopackage file
      if(str_detect(glLayerDF[k,"name"], ".gpkg")){
        
        # Retrieve path of shp file to define dsn
        shpDir <- glLayerDF[k,"datapath"]
        
        # Extract shp file name without extension to define layer name
        shpLayer <- gsub(".gpkg","", glLayerDF[k,"name"])
      }
      
      
      curLay <- readOGR(dsn = shpDir, layer = shpLayer, verbose = FALSE)
      
    }
    
    
    #If raster
    if(glLayerDF[k,"layerType"]==lRast[indLang]){
      
      curLay <- raster(glLayerDF[k,"datapath"])
      
    }
    
    # If csv mobility file
    if(layerFiles[k,"layerType"]==lMob[indLang]){
      
      curLay <- read_network(layerFiles[k,"datapath"])
      
    }
    
    
    curLayerName <- paste("layer_", glLayerDF[k,"shortName"], sep = "")
    
    # Pre-allocate list for layer
    curLayerList <- vector("list", nbLayIndex)
    curLayerList[[indRawLay]] <- curLay
    curLayerList[[indScale]] <- NA
    curLayerList[[indStandLay]] <- NA
    
    #Save in global environment the current layer
    assign(x = curLayerName, 
           value = curLayerList, 
           envir = .GlobalEnv)
    
  }
  
  #Initialize weight matrix
  glWeightMatrix <- matrix(data = 1.0, nrow = nbLayer, ncol = nbLayer, dimnames = list(layerNames, layerNames))
    
  
  
  
  rm(nbFiles, indVect, indRast, indRem, fileExt, nbLayer, layerNames)
  
}


