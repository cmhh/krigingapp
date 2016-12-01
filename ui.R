shinyUI(basicPage(
      absolutePanel(leafletOutput("map", height="100%", width="100%"), top=0, bottom=0, left=0, right=0),
      absolutePanel(shiny::actionButton("reset", "reset extent"), bottom="15px", left="15px"),
      absolutePanel(wellPanel(
         selectInput("region", "Region:", choices=rc.list),
         uiOutput("tacontainer")
      ), top=20, right=20, style="min-width: 400px;")
))