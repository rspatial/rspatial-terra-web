
args <- commandArgs(TRUE)
if (length(args) > 0) {
	cmd <- args[1]
	if (cmd == "remove") {
		unlink("build", recursive=TRUE)
	}
}

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


# copy pdf manuals
# shell("make pdf")
# cat("copying pdfs\n\n")
#f <- list.files("source", patt='.pdf$', recursive=TRUE, full=TRUE)
#if(length(f) < 4) {warning("pdf files missing")}
#g <- gsub("/_build/latex", "", f)
#g <- gsub("source/", "", g)
#h <- file.path("build/html", g)
#dir.create(dirname(h), TRUE, FALSE)
#y <- file.copy(f, h, overwrite=TRUE)
#stopifnot(all(y))


