server <- function(input, output, session) {
    # Reactive data: Load and filter based on inputs
    drought_data <- reactive({
        data <- read.csv("data/drought_data.csv") # Replace with your actual data file
        subset(data, Variable == input$variable & Date >= input$dateRange[1] & Date <= input$dateRange[2])
    })

    # Generate an interactive plot
    output$droughtPlot <- renderPlotly({
        ggplotly(
            ggplot(drought_data(), aes(x = Date, y = Value)) +
                geom_line(color = "blue") +
                labs(
                    title = paste("Visualization of", input$variable),
                    x = "Date", y = "Value"
                ) +
                theme_minimal()
        )
    })

    # Render a data table
    output$droughtTable <- renderDataTable({
        datatable(drought_data(), options = list(pageLength = 10, autoWidth = TRUE))
    })

    # Download handler for filtered data
    output$downloadData <- downloadHandler(
        filename = function() {
            paste("filtered_data_", Sys.Date(), ".csv", sep = "")
        },
        content = function(file) {
            write.csv(drought_data(), file)
        }
    )
}
