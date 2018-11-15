1 a\#' title: "Rdionica: priprema datoteke `podaci_upitnik.csv` za obradu"\
#' author: "Denis Vlašiček"\
#' date: ""\
#' toc: true\

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
