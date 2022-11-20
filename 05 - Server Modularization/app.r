library(shiny)

# exFUN	<-	function(n, r = 2)	runif(n, min = 0, max = 9) |> round(r)
exFUN	<-	function(n)	runif(n, min = 0, max = 9)


exampleUI	<-	function(name)	{
	ns	<-	NS(name)

	tagList(
		fluidRow(
			column(2,	numericInput(inputId = ns('randCount'),	label = paste0("Count ", name),	value = 3,	min = 0)),
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

#	directly calling moduleServer
server	<-	function(input, output, session)	{
	moduleServer('modules', function(input, output, session)	{
		exTAB	<-	reactive(exFUN(input$randCount))

		output$TAB	<-	renderTable(exTAB())
	})
	
	output$modules	<-	renderUI({	exampleUI('modules')	})
}

shinyApp(ui, server)


#	functional but only one module
server	<-	function(input, output, session)	{
	exampleServer	<-	function(name)	{moduleServer(name, function(input, output, session)	{
			exTAB	<-	reactive(exFUN(input$randCount))

			output$TAB	<-	renderTable(exTAB())
		})
	}
	exampleServer('modules')
	output$modules	<-	renderUI({	exampleUI('modules')	})
}

shinyApp(ui, server)


#	multiple modules
server	<-	function(input, output, session)	{
	exampleServer	<-	function(name)	{moduleServer(name, function(input, output, session)	{
			exTAB	<-	reactive(exFUN(input$randCount))

			output$TAB	<-	renderTable(exTAB())
		})
	}
	modList	<-	reactive(	as.character(1:input$modCount)	)

	observe({
		lapply(modList(),	exampleServer)
		output$modules	<-	renderUI(	lapply(modList(),	exampleUI)	)
	})
}

shinyApp(ui, server)


#	final version
server	<-	function(input, output, session)	{
	exampleServer	<-	function(name)	{
		moduleServer(name, function(input, output, session)	{
			exTAB	<-	reactive(exFUN(input$randCount))

			output$TAB	<-	renderTable(exTAB(),	striped = reactive(input$striping))
		})
	}

	modList	<-	reactive(	as.character(1:input$modCount)	)

	observe({
		lapply(modList(),	exampleServer)
		output$modules	<-	renderUI(	lapply(modList(),	exampleUI)	)
	})
}

shinyApp(ui, server)
