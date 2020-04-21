
library(shiny)
url = 'http://www4.stat.ncsu.edu/~stefanski/NSF_Supported/Hidden_Images/orly_owl_files/orly_owl_Lin_4p_5_flat.txt'
    download.file(url, "owl.txt")
    owl = read.table("owl.txt", header = FALSE)
    colnames(owl) = c("V1", "V2", "V3", "V4", "V5")
    
ui <- fluidPage(
    titlePanel("Peek-an-owl!"),
    sidebarLayout(
        sidebarPanel(
            h3("Scatter plot"),
            selectInput("Variable1", "Choose the x variable", list("V1", "V2", "V3", "V4", "V5"), selected = "V3"),
            selectInput("Variable2", "Choose the y variable",list("V1", "V2", "V3", "V4", "V5"), selected = "V3"),
            h3("Linear regression"),
            selectInput("Variable3", "Choose the outcome variable for linear regression",list("V1", "V2", "V3", "V4", "V5"), selected = "V3"),
            submitButton("Submit"),
            p("Codes are available ",
        a("here.", 
          href = "http://shiny.rstudio.com")),
        ),
        mainPanel(
            h2("Scatter Plot"),
            p("In this interactive shiny app we will look for a hidden message in a noisy dataset. This dataset comprises of five columns and 2298 rows. The name of the columns are V1, V2, V3, V4 and V5. In the input fields on the left, choose any pair of the variables to be plotted below."),
            plotOutput("scatterPlot"),
            h2("Let's find the hidden message!"),
            p("It turns out that there is actually a hidden message in this dataset! If we fit the dataset through a linear regression model by choosing the correct variable as the outcome and all other variables as predictors/regressors, the residual vs fitted plot for this linear model will reveal a hidden message!"),
            p("For example, if we choose V3 as the outcome variable for linear regression, the code run would be:"),
            code("fit <- lm(V3 ~ . -1, data = owl)"),
            br(),
            code("plot(predict(fit), resid(fit), pch = '.')"),
            p("Select one variable in the input field on the side panel as the outcome variable for linear regression, and then click the submit button to run the linear regression model."),
            plotOutput("residualPlot"),
            h2("Summary of the linear regression model"),
            textOutput("modelSummary")
            
        )
    ))

server <- function(input, output) {
    output$scatterPlot = renderPlot(
        plot(as.formula(paste(input$Variable2,'~',input$Variable1)), data = owl, main = "Scatter plot of noisy dataset", xlab = input$Variable1, ylab = input$Variable2, xlim = c(-3,3), ylim = c(-3,3))
    )
    fit <- reactive(lm(as.formula(paste(input$Variable3, "~ . -1")), data = owl))
    output$residualPlot = renderPlot(plot(predict(fit()), resid(fit()), pch = '.', main = "Hidden message plot", xlab = "fitted values", ylab = "residuals",))
    output$modelSummary = renderPrint(summary(fit()))
}

shinyApp(ui = ui, server = server)
