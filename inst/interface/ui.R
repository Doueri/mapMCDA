################### PURPOSE OF THE APP ###################
#Interface for PRODEL project
#May 2018, by Sylvain Falala, Unit CIRAD-INRA ASTRE



################### UI ###################

sidebar <- dashboardSidebar(
  
  sidebarMenu(id = "tabs",
    
    # Menu for input files
    menuItem(HTML(langMenuFile[indLang]), tabName = "fileTab"),
    
    # Menu for epidemiological unit
    menuItem(HTML(langMenuUnit[indLang]), tabName = "unitTab"),
    
    # Menu for risk factors
    menuItem(HTML(langMenuRisk[indLang]), tabName = "riskTab"),
    
    # Menu for weight table
    menuItem(HTML(langMenuWeight[indLang]), tabName = "weightTab"),
    
    # Menu for results
    menuItem(HTML(langMenuResult[indLang]), tabName = "resultTab")
    
  )
)


body <- dashboardBody(
  
  tabItems(
    
    tabItem("fileTab", 
            
            fluidRow(
              ## File load
              box(
                title = HTML(langBoxFile[indLang]),
                status = "primary",
                width = 5,
                solidHeader = TRUE,
                footer = langHelpFiles[indLang],
                
                # To upload shape and raster files
                fileInput(
                  inputId = "fiLayer",
                  label = HTML(langTitleFileInput[indLang]),
                  multiple = TRUE,
                  accept = NULL,
                  #acceptLayerType,
                  width = NULL,
                  buttonLabel = HTML(langButtonFileInput[[indLang]][1]),
                  placeholder = HTML(langButtonFileInput[[indLang]][2])
                ),
                
                # List of all upload files
                tableOutput("allFileTable")
                
              ),
              
              ## Layer table
              box(
                title = HTML(langBoxLayer[indLang]),
                status = "success",
                width = 7,
                solidHeader = TRUE,
                footer = langHelpLayers[indLang],
                
                # List of layers. Name is editable
                rHandsontableOutput("rhLayerTable")
                
              )
              
            )
            
    ),
    
    tabItem(
      "unitTab",
      
      uiOutput("unitNameText"),
      
      box(
        title = HTML(langBoxUnitMap[indLang]),
        status = "primary",
        width = 6,
        solidHeader = TRUE,
        
        plotOutput("unitMapDisplay")
      ),
      
      
      box(
        title = HTML(langBoxUnitStat[indLang]),
        status = "success",
        width = 6,
        solidHeader = TRUE,
        
        textOutput("unitStatText"),
        plotOutput("unitStatDisplay")
      )
      
    ),
    
    
    tabItem(
      "riskTab",
      
      uiOutput("uiRiskLayerList"),
      
      box(
        title = HTML(langBoxRiskRawMap[indLang]),
        status = "primary",
        width = 6,
        solidHeader = TRUE,
        
        plotOutput("rawLayerDisplay")
        
      ),
      
      
      box(
        title = HTML(langBoxRiskStandRaster[indLang]),
        status = "success",
        width = 6,
        solidHeader = TRUE,
        
        
        plotOutput("standRasterDisplay")
        
      ),
      
      box(
        status = "info",
        width = 6,
        solidHeader = FALSE,
        
        langHelpScale[indLang]
        
      ),
      
      
      actionButton(
        inputId = "abInvert",
        label = langABRiskRasterInvert[indLang]
      )
    ),
    
    tabItem("weightTab",
            
            fluidRow(
              box(
                title = HTML(langBoxWeightMatrix[indLang]),
                status = "primary",
                width = 9,
                solidHeader = TRUE,
                
                
                rHandsontableOutput("rhWeightTable")#,
                
                # actionButton(inputId = "abWMatrixOK", label = "Valider"),
                #
                # textOutput("isMatrixOKText")
                
                
              ),
              
              box(
                status = "info",
                width = 3,
                solidHeader = FALSE,
                
                langHelpMatrix[indLang]
              )
              
            ),
            
            fluidRow(
              box(
                title = HTML(langBoxWeightBar[indLang]),
                status = "success",
                width = 12,
                solidHeader = TRUE,
                
                plotOutput("weightBarDisplay")
                
              )
              
            )),

    tabItem("resultTab",
            
              box(title = HTML(langMenuResult[indLang]), status = "primary", width = 6, solidHeader = TRUE,
                  
                  plotOutput("resultDisplay"),
                  
                  #Button to generate and download raster
                  downloadButton(outputId = "exportResultRaster", 
                                 label = "Export raster")
                  
              ),
            
              box(title = HTML(langAdminUnitResult[indLang]), status = "success", width = 6, solidHeader = TRUE,
                  
                  selectInput(inputId = "siLevelRisk", 
                              label = HTML(langLevelResult[indLang]),
                              choices = 1:12,
                              selected = 4),
                  
                  plotOutput("resultUnitDisplay"),
                  
                  #Button to generate and download vector
                  downloadButton(outputId = "exportResultVector", 
                                 label = "Export vector"),
                  
                  #Button to generate and download csv table
                  downloadButton(outputId = "exportResultCSV", 
                                 label = "Export table")
                  
              )

            
            )
    
  )
  
  
  
)


dashboardPage(
  dashboardHeader(title = appTitle),
  sidebar,
  body
)

