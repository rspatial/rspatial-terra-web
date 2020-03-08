
ff <- list.files("build/html", patt='\\.html$', recursive=TRUE, full=TRUE)

ignore_errors <- c("build/html/intr/2-basic-data-types.html", "build/html/intr/7-explore.html"
,"build/html/intr/8-functions.html", "build/html/intr/9-apply.html")

for (f in ff) {
	x <- readLines(f, warn=FALSE)
	i <- grep("## Error", x)
	if (length(i) > 0) {
		if (f %in% ignore_errors) {
			if (length(i) < 5) next
		}
		print(f)
		print(head(x[i]))
		cat("----\n\n")
	}
}

