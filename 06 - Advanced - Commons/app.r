library(shiny)

# exFUN	<-	function(n, r = 2)	runif(n, min = 0, max = 9) |> round(r)
exFUN	<-	function(n)	runif(n, min = 0, max = 9)


exampleUI	<-	function(name, VAL = 3)	{
	ns	<-	NS(name)

	tagList(
		fluidRow(
			column(2,	numericInput(inputId = ns('randCount'),	label = paste0("Count ", name),	value = VAL,	min = 0)),
			column(2,	checkboxInput(inputId = ns('striping'),	label = "Table Striping")),
		),
		tableOutput(ns('TAB'))
	)
}

ui	<-	fluidPage(
	titlePanel(NULL,	"Shiny Modularization Example"),
	fluidRow(
		column(2,	numericInput(inputId = 'modCount',	label = "Module Count",	value = 2,	min = 1)),
		column(2,	numericInput(inputId = 'roundTerm',	label = "Rounding Term",	value = 2)),
	),
	uiOutput('modules'),
)

#	roundTerm as argument
server	<-	function(input, output, session)	{
	exampleServer	<-	function(name, roundTerm = reactive(input$roundTerm))	{
		moduleServer(name, function(input, output, session)	{
			exTAB	<-	reactive(exFUN(input$randCount))

			output$TAB	<-	renderTable(exTAB(),	digits = reactive(roundTerm()),	striped = reactive(input$striping))
		})
	}

	modList	<-	reactive(	as.character(1:input$modCount)	)

	observe({
		lapply(modList(),	exampleServer, reactive(input$roundTerm))
		output$modules	<-	renderUI(	lapply(modList(),	exampleUI)	)
	})
}

#	roundTerm as common
server	<-	function(input, output, session)	{
	exampleServer	<-	function(name)	{	roundTerm	<-	reactive(input$roundTerm)
		moduleServer(name, function(input, output, session)	{
			exTAB	<-	reactive(exFUN(input$randCount))

			output$TAB	<-	renderTable(exTAB(),	digits = reactive(roundTerm()),	striped = reactive(input$striping))
		})
	}

	modList	<-	reactive(	as.character(1:input$modCount)	)

	observe({
		lapply(modList(),	exampleServer)
		output$modules	<-	renderUI(	lapply(modList(),	exampleUI)	)
	})
}

shinyApp(ui, server)
