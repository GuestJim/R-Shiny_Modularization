exFUNC	<-	function(n, r = 2)	{
	out	<-	runif(n, min = 0, max = 9)
	return(round(out, r))
}

exFUN	<-	function(n, r = 2) round(runif(n, min = 0, max = 9), r)

out	<-	0
exFUN	<-	function(n, r = 2) {
	out	<-	runif(n, min = 0, max = 9)
	return(round(out, r))
}
exFUN(2)
out

rm(out)
exFUN	<-	function(n, r = 2) {
	out <<- runif(n, min = 0, max = 9)
	return(round(out, r))
}
exFUN(2)
out