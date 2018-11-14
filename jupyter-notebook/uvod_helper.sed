1 a\#' title: "Rdionica: Uvod u R"\
#' author: "Denis Vlašiček"\
#' date: ""\
#' toc: true\

/.*version.*/{
N
/.*#' ---/ a\#+ setup, include=F, echo=F\
knitr::opts_chunk$set(collapse=T)
}

/^\.3 <-/ i\#+ error=T

/^for <- 5/ i\#+ error=T

/is\.numeric\(1,4141\)/ i\#+ error=T

/.*svim stupcima jer će se R inače požaliti\./ a\#+ error=T

/.*vrijednost `FALSE`, a `\[\]` nema tu mogućnost/ a\#+ error=T

/.*\\frac\{.*\}/ {
s/je \$/je \\(/g
s/\$/\\)/g
}

/^#' #+ [[:alnum:]]+/ i\#'
