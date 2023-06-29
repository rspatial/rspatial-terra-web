
dopdf <- FALSE
args <- commandArgs(TRUE)
if (length(args) > 0) {
	cmd <- args[1]
	if (cmd == "clean") {
		unlink("build", recursive=TRUE)
	} else if (cmd == "pdf") {
		dopdf=TRUE
	}
}


if (!dopdf) {
	shell("make html")

	fff <- list.files("build/html", patt='\\.html$', recursive=TRUE, full=TRUE)
	for (f in fff) {
		d <- readLines(f, warn=FALSE)
		dd <- trimws(d)
		d <- d[dd != ""]
		if (basename(f) != "index.html") {
			d <- gsub("\\.rst\\.txt", ".R.txt", d)
		}
		writeLines(d, f)	
	}

	cat("copying source\n\n")
	f <- list.files("source", patt='\\.txt$', recursive=TRUE, full=TRUE)
	f <- grep("/txt/", f, value=TRUE)
	g <- gsub("txt/", "", f)
	g <- gsub("source/", "", g)
	h <- file.path("build/html/_sources", g)
	h <- gsub("\\.txt$", ".R.txt", h)
	y <- file.copy(f, h, overwrite=TRUE)

	#cat("copying images\n\n")
	#f <- list.files("source", patt='\\.png$', recursive=TRUE, full=TRUE)
	#g <- file.path("build/html/images", basename(f))
	#y <- file.copy(f, g, overwrite=TRUE)

	ff <- list.files("build/html", patt='\\.html$', recursive=TRUE, full=TRUE)

	ignore_errors <- "Error in read.table(f, header = TRUE): more columns than column names</span>"
		
	ignore_errors2 <- c("Error in eval(expr, envir, enclos): object &#39;Yi", "Error in quantile.default(d$score2): missing value", "Error: &#39;\\p&#39; is an unrecognized escape in c",
    "Error in nrow(): argument &quot;x&quot; is missing", "Error in sumsquare(a = 1, d = 2): unused argument ",
"Error in sumsquare(1:5): argument &quot;b&quot; is", "Error in f1(x, ...): unused argument (z = 5)</span", "Error in aggregate.data.frame(d[, c(&quot;v1&quot;")

	
	
	txtin <-  'R.txt" rel="nofollow"> View page source</a>'
	txtout <- 'R.txt" rel="nofollow"> <em>R</em> code</a>'
	txt2 <- '.rst.txt" rel="nofollow"> View page source</a>$'

	for (f in ff) {
		x <- readLines(f, warn=FALSE)
		e <- grep("## Error", x, value=TRUE)
		e <- gsub("<span class=\"c1\">## ", "", e)
		e <- gsub('<div class=\"highlight-default notranslate\"><div class=\"highlight\"><pre><span></span><span class=\"c1\">', "", e)
	    e <- gsub('<div class=\"highlight-default notranslate\"><div class=\"highlight\"><pre><span></span>', "", e)
		e <- substr(e, 1, 125)
		e <- e[!(e %in% ignore_errors)]
		e <- substr(e, 1, 50)
		e <- e[!(e %in% ignore_errors2)]

		if (length(e) > 0) {
			print(f)
			print(e)
			cat("----\n\n")
		}
		x <- gsub(txtin, txtout, x)
		i <- grep(txt2, x)
		x[i] <- paste("<!--", x[i], "-->")
		writeLines(x, f)
	}



} else { #if (dopdf) {
	print("dopdf")

	if (tolower(Sys.info()["sysname"])=="windows"){
		sysfun <- shell
	} else {
		sysfun <- system		  
	}

	sites <- list.files("source", full=TRUE)
	sites <- sites[!grepl("\\_", sites)]
	sites <- sites[!grepl("\\.", sites)]
	wd <- getwd()
	for (site in sites) {
		setwd(wd)
		cat("\n\n===================================\n")
		cat(site)
		cat("\n-----------------------------------\n")
		setwd(site)
		x <- sysfun("make latexpdf", intern = TRUE)
		cat("\n\n-----------------------------------	\n")
	}
	setwd(wd)
	#shell("make latexpdf")
	cat("copying pdfs\n\n")
	f <- list.files("source", patt='.pdf$', recursive=TRUE, full=TRUE)
	if(length(f) < 6) {warning("pdf files missing")}
	g <- gsub("/_build/latex", "", f)
	g <- gsub("source/", "", g)
	h <- file.path("build/html", g)
	x <- sapply(h, function(f) dir.create(dirname(f), FALSE, TRUE))
	y <- file.copy(f, h, overwrite=TRUE)
	stopifnot(all(y))
}

