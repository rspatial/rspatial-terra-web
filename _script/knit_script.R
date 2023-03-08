

args = commandArgs(trailingOnly=TRUE)
ff = args[1]
quiet = as.logical(args[2])

outf <- gsub("_R/", "", ff)
md <-  gsub(".rmd$", '.md', outf)
txtp <- file.path(dirname(outf), "txt", basename(outf))
rcd <- gsub(".rmd$", ".txt", txtp)

k = loadNamespace("knitr")

knitr::opts_chunk$set(
	dev        = 'png',
	fig.width  = 6,	fig.height = 6,
	fig.path = 'figures/',
	fig.cap="",
	collapse   = TRUE
)
#opts_chunk$set(tidy.opts=list(width.cutoff=60))

dn <- dirname(md)
if (dn != ".") {
	knitr::opts_chunk$set(
		fig.path = paste0(dn, '/figures/')
	)
	fdirclean <- TRUE
} else {
	fdirclean <- FALSE
}

k = knitr::knit(ff, md, envir = new.env(), encoding='UTF-8', quiet=quiet)
k = knitr::purl(ff, rcd, quiet=TRUE)
if (fdirclean) {
	x <- readLines(md)
	j <- grep("png", x)
	x[j] = gsub(paste0(dn, "/"), "", x[j])
	writeLines(x, md)
}


