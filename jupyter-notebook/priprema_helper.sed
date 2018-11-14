1 a\#' title: "Rdionica: priprema datoteke `podaci_upitnik.csv` za obradu"\
#' author: "Denis Vlašiček"\
#' date: ""\
#' toc: true\

/^options/ {
N
d
}

/#' # Uvod/ i\#+ setup, include=F, echo=F\
knitr::opts_chunk$set(collapse=T)

/install.packages/ i\#+ eval=F

/^DataExplorer::create_report(podaci)$/ i\#+ eval=F

/^print(skimr::skim.*/ i\#+ eval=F
