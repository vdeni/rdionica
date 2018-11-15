1 a\#' title: ""\
#' author: "Denis Vlašiček"\
#' date: ""\
#' output:\
#'     html_document:\
#'         theme: lumen\
#'         highlight: tango\
#'         toc: true\
#'         toc_float: true\
#'     pdf_document:\
#'         toc: true

/^options/ {
N
d
}

/.*version.*/{
N
/.*#' ---/ a\#+ setup, include=F, echo=F\
knitr::opts_chunk$set(collapse=T, fig.pos='!h')
}

/install.packages/ i\#+ eval=F

/zgodno-korisna i bez njih/ a\#+ eval=F

/^print(skimr::skim.*/ i\#+ eval=F
