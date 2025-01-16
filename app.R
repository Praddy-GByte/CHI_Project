# app.R

# Load necessary libraries
library(shiny)
library(leaflet)
library(plotly)
library(sf)
library(ncdf4)
library(dplyr)

# Placeholder function to fetch comments
fetch_comments <- function() {
  data.frame(
    title = c("Nature Conservation", "Central Arizona Project", "KGL "),
    link = c("#", "#", "#"),
    summary = c(
      "The Colorado River is experiencing a historic drought, with water levels at record lows.",
      "The river's flow has declined by 20% over the past century, and scientists predict it could shrink by 31% by 2050.",
      "A study found that the region has lost more water than Lake Mead can hold since 2000."
    ),
    review = c(
      "This is an alarming trend that needs immediate action.",
      "The projections are concerning, but it's still unclear how much mitigation can happen.",
      "The loss of water is a major issue that must be addressed in policy discussions."
    ),
    stringsAsFactors = FALSE
  )
}

# UI
ui <- fluidPage(
  # Include external CSS and JS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$script(HTML("
      $(document).ready(function() {
        let quotes = $('.news-item');
        let index = 0;
        function showNextQuote() {
          quotes.hide();
          $(quotes[index]).fadeIn();
          index = (index + 1) % quotes.length;
          setTimeout(showNextQuote, 4000); // Slide every 4 seconds
        }
        showNextQuote();
      });
    "))
  ),

  # Navbar with logos and title
  div(
    class = "navbar navbar-expand-lg navbar-dark bg-dark w-100",
    style = "padding-top: 15px;", # Add padding to the top of the navbar for better spacing
    div(
      class = "container-fluid",
      div(
        class = "d-flex justify-content-between align-items-center w-100",
        tags$div(
          class = "navbar-brand",
          style = "display: flex; flex-direction: row; align-items: center;", # Ensures horizontal arrangement
          tags$img(src = "ASU.png", height = "30px", style = "margin-right: 10px;"),
          tags$img(src = "Nasa.png", height = "30px", style = "margin-right: 10px;"),
          tags$img(src = "cap.png", height = "30px", style = "margin-right: 10px;")
        ),
        tags$div(
          tags$span("Managing the Colorado River as Infrastructure Asset",
            style = "margin-centre: 10px; font-weight: bold; color: darkblue; font-size: 2em;"
          )
        )
      )
    )
  ),

  # Main content with navigation tabs
  navbarPage(
    title = NULL,

    # Home Tab
    tabPanel("Home", fluidPage(
      # Title above the map
      h3("Colorado River Visualization Dashboard",
        style = "font-size:20px ;font-weight: bold; text-align: center; margin-bottom: 20px; color: light black;"
      ),

      # Home Map
      leafletOutput("homeMap"),

      # Alert Section (Horizontal Layout)
      div(
        class = "alert-section",
        style = "display: flex; justify-content: space-around; margin-top: 20px; padding: 15px 0;",

        # Alert 1 - Reservoir Level: Low (Critical)
        div(
          class = "alert-box",
          style = "background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 10px; border-radius: 5px; width: 30%; text-align: center;",
          h4("Reservoir Level: Low (Critical)", style = "font-weight: bold; color: #721c24;")
        ),

        # Alert 2 - Snowpack Level: Below Average (Warning)
        div(
          class = "alert-box",
          style = "background-color: #fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 5px; width: 30%; text-align: center;",
          h4("Snowpack Level: Below Average (Warning)", style = "font-weight: bold; color: #856404;")
        ),

        # Alert 3 - Drought Level: Severe (Critical)
        div(
          class = "alert-box",
          style = "background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 10px; border-radius: 5px; width: 30%; text-align: center;",
          h4("Drought Level: Severe (Critical)", style = "font-weight: bold; color: #721c24;")
        )
      ),

      # News Section for Updates
      div(id = "news_section", uiOutput("news_section"))
    )),

    # Contact Tab
    tabPanel("Contact", fluidPage(
      h4("Contact Us"),
      textInput("name", "Name:"),
      textInput("email", "Email:"),
      textInput("report", "Report:"),
      actionButton("submit", "Submit")
    )),

    # Spatial Analysis Tab
    tabPanel("Spatial Analysis", fluidPage(
      h4("Spatial Analysis"),
      leafletOutput("mapPlot")
    )),

    # Temporal Analysis Tab
    tabPanel("Temporal Analysis", fluidPage(
      h4("Temporal Analysis"),
      tabsetPanel(
        tabPanel("Reservoir Level", plotlyOutput("reservoirPlot")),
        tabPanel("Snowpack Level", plotlyOutput("snowpackPlot")),
        tabPanel("Water Flow", plotlyOutput("waterFlowPlot")),
        tabPanel("Additional Chart 1", plotlyOutput("additionalChart1")),
        tabPanel("Additional Chart 2", plotlyOutput("additionalChart2")),
        tabPanel("Additional Chart 3", plotlyOutput("additionalChart3")),
        tabPanel("Additional Chart 4", plotlyOutput("additionalChart4")),
        tabPanel("Additional Chart 5", plotlyOutput("additionalChart5"))
      )
    )),

    # Watershed Tab
    tabPanel("Watershed", fluidPage(h4("Watershed Analysis"))),

    # Drought Tab
    tabPanel("Drought", fluidPage(h4("Drought Analysis"))),

    # Snow Tab
    tabPanel("Snow", fluidPage(h4("Snow Analysis")))
  ),

  # Footer with social media and website links
  div(
    class = "footer",
    div(
      class = "footer-content",
      "© 2025 Colorado River Basin Scenario Explorer",
      align = "center"
    ),
    div(
      class = "social-links",
      style = "text-align: center; margin-top: 10px;",
      tags$a(
        href = "https://www.facebook.com", target = "_blank",
        tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Facebook_f_logo_%282019%29.svg/1200px-Facebook_f_logo_%282019%29.svg.png", height = "30px", style = "margin-right: 10px;")
      ),
      tags$a(
        href = "https://github.com", target = "_blank",
        tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/9/91/Octicons-mark-github.svg", height = "30px", style = "margin-right: 10px;")
      ),
      tags$a(
        href = "https://www.instagram.com", target = "_blank",
        tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png", height = "30px", style = "margin-right: 10px;")
      ),
      tags$a(
        href = "https://chi.asu.edu/", target = "_blank",
        tags$img(src = "https://chi.asu.edu/wp-content/uploads/sites/13/2023/04/ASU-CHI-Horiz-RGB-White-600ppi.png", height = "30px", style = "margin-right: 10px;")
      )
    )
  )
)

# Server
server <- function(input, output) {
  # Load spatial data using sf
  shp_data <- st_read("data/basin_CRB_poly.shp")

  # Example Reservoir plot (Line Chart)
  output$reservoirPlot <- renderPlotly({
    plot_ly(
      x = 1:100, # Example data for x-axis
      y = rnorm(100), # Example data for y-axis
      type = "scatter",
      mode = "lines",
      name = "Reservoir Level",
      line = list(color = "blue")
    )
  })

  # Example Snowpack plot (Line Chart)
  output$snowpackPlot <- renderPlotly({
    plot_ly(
      x = 1:100,
      y = rnorm(100),
      type = "scatter",
      mode = "lines",
      name = "Snowpack Level",
      line = list(color = "green")
    )
  })

  # Example Water flow plot (Line Chart)
  output$waterFlowPlot <- renderPlotly({
    plot_ly(
      x = 1:100,
      y = rnorm(100),
      type = "scatter",
      mode = "lines",
      name = "Water Flow",
      line = list(color = "cyan")
    )
  })

  # Example Additional Charts (Line Chart)
  output$additionalChart1 <- renderPlotly({
    plot_ly(
      x = 1:100,
      y = rnorm(100),
      type = "scatter",
      mode = "lines",
      name = "Additional Chart 1",
      line = list(color = "red")
    )
  })

  # Home Map with satellite, terrain, Google Earth, MODIS, GRASS, and SNOTEL base layers
  output$homeMap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
      addProviderTiles(providers$OpenTopoMap, group = "Terrain") %>%
      # Add Google Earth as a custom base layer
      addTiles(
        urlTemplate = "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
        group = "Google Earth"
      ) %>%
      # Add MODIS tiles (example of MODIS imagery tiles)
      addTiles(
        urlTemplate = "https://gibs.earthdata.nasa.gov/wmts/epsg4326/best/MODIS_Terra_Surface_Reflectance/default/1.1.1/{z}/{y}/{x}.jpg",
        group = "MODIS"
      ) %>%
      # Add GRASS or another open source mapping layer (if using a tile server)
      addProviderTiles(providers$OpenStreetMap, group = "GRASS") %>%
      # Add SNOTEL data (SNOTEL station data, if accessible as tiles, or a general weather layer)
      addTiles(
        urlTemplate = "https://example.com/snotel_tiles/{z}/{x}/{y}.png",
        group = "SNOTEL"
      ) %>%
      addLayersControl(
        baseGroups = c("Satellite", "Terrain", "Google Earth", "MODIS", "GRASS", "SNOTEL"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      setView(lng = -105.0, lat = 39.7, zoom = 6)
  })

  # Map for Spatial Analysis
  output$mapPlot <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
      addProviderTiles(providers$OpenTopoMap, group = "Terrain") %>%
      addPolygons(data = shp_data, color = "blue", weight = 1, opacity = 1, fillOpacity = 0.5) %>%
      addLayersControl(
        baseGroups = c("Satellite", "Terrain", "Google Earth", "MODIS", "GRASS", "SNOTEL"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      setView(lng = -105.0, lat = 39.7, zoom = 6)
  })

  # News section with quotes and manual reviews
  output$news_section <- renderUI({
    comments <- fetch_comments()
    tagList(
      lapply(1:nrow(comments), function(i) {
        div(
          class = "news-item",
          tags$blockquote(tags$p(comments$summary[i])),
          tags$cite(tags$a(href = comments$link[i], comments$title[i])),
          tags$br(),
          # Add manual review section
          tags$strong("Manual Review:"),
          tags$p(comments$review[i]) # Display the review
        )
      })
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
