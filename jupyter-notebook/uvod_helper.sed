1 a\#' title: ""\
#' author: "Denis Vlašiček"\
#' date: ""\
#' output:\
#'     html_document:\
#'         toc: true\
#'         toc_float: true\
#'     pdf_document:\
#'         toc: true

/.*version.*/{
N
/.*#' ---/ a\#+ setup, include=F, echo=F\
knitr::opts_chunk$set(collapse=T)
}

/^\.3 <-/ i\#+ error=T

/^for <- 5/ i\#' ```
/^for <- 5/ a\#' Error: unexpected assignment in "for <-"\n#' ```
s/^for <- 5/#' for <- 5/

/is\.numeric\(1,4141\)/ i\#' ```
/is\.numeric\(1,4141\)/ a\#' 2 arguments passed to 'is.numeric' which requires 1
s/is\.numeric\(1,4141\)/#' is.numeric(1,4141)/

/1,5151 \+ 1/ a\#' Error: unexpected ',' in "1,"\n#' ```
s/1,5151 \+ 1/#' 1,5151 + 1/

/.*svim stupcima jer će se R inače požaliti\./ a\#+ error=T

/.*vrijednost `FALSE`, a `\[\]` nema tu mogućnost/ a\#+ error=T

/.*\\frac\{.*\}/ {
s/je \$/je \\(/g
s/\$/\\)/g
}

/^#' #+ [[:alnum:]]+/ i\#'

/^#'.*R razlikuje.*tipova podataka:/ a\#'

/^#'.*Osim što.*se u sljedećem:/ a\#'
