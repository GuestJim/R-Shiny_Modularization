library(shiny)

# exFUN	<-	function(n, r = 2)	runif(n, min = 0, max = 9) |> round(r)
exFUN	<-	function(n)	runif(n, min = 0, max = 9)

ui	<-	fluidPage(
	titlePanel(NULL,	"Shiny Modularization Example"),
	fluidRow(
		column(2,	numericInput(inputId = 'roundTerm',	label = "Rounding Term",	value = 2)),
	),
	fluidRow(
		column(2,	numericInput(inputId = 'randCount',	label = "Count",	value = 3,	min = 0)),
		column(2,	checkboxInput(inputId = 'striping',	label = "Table Striping")),
	),
	tableOutput('TAB'),
)


server	<-	function(input, output, session)	{
	exTAB	<-	reactive(exFUN(input$randCount))

	output$TAB	<-	renderTable(exTAB(),	digits = reactive(input$roundTerm),	striped = reactive(input$striping))
}

shinyApp(ui, server)
