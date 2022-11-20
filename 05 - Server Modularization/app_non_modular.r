library(shiny)

# exFUN	<-	function(n, r = 2)	runif(n, min = 0, max = 9) |> round(r)
exFUN	<-	function(n)	runif(n, min = 0, max = 9)


exampleUI	<-	function()	{
	tagList(
		fluidRow(
			column(2,	numericInput(inputId = 'randCount',	label = "Count ",	value = 3,	min = 0)),
			column(2,	checkboxInput(inputId = 'striping',	label = "Table Striping")),
		),
		tableOutput('TAB'),
	)
}

ui	<-	fluidPage(
	titlePanel(NULL,	"Shiny Modularization Example"),
	fluidRow(
		column(2,	numericInput(inputId = 'modCount',	label = "Module Count",	value = 2,	min = 1)),
		column(2,	numericInput(inputId = 'roundTerm',	label = "Rounding Term",	value = 2)),
	),
	exampleUI(),
)

server	<-	function(input, output, session)	{
	exampleServer	<-	function()	{
			exTAB	<-	reactive(exFUN(input$randCount))

			output$TAB	<-	renderTable(exTAB())
	}
	exampleServer()
}

shinyApp(ui, server)
