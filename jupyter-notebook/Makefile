.PHONY: all
.SUFFIXES: .R .html .pdf

all: priprema_podaci_upitnik.html priprema_podaci_upitnik.pdf priprema_podaci_upitnik.R\
	r_uvod.html r_uvod.pdf r_uvod.R

%.R: %.ipynb
	jupytext -o $@ $<
	sed -e '/slidesh/d;/.*coding: utf.*/d' $@ > tmp.txt
	mv tmp.txt $@
	if [ $@ = 'priprema_podaci_upitnik.R' ];\
	    then\
	    sed -f priprema_helper.sed $@ > tmp.txt;\
	    mv tmp.txt $@;\
	elif [ $@ = 'r_uvod.R' ];\
	    then\
	    sed -Ef uvod_helper.sed $@ > tmp.txt;\
	    mv tmp.txt $@;\
	fi

.R.html:
	Rscript -e 'rmarkdown::render("$<", output_format = "html_document", output_dir = "../docs")'

.R.pdf:
	Rscript -e 'rmarkdown::render("$<", output_format = "pdf_document", output_dir = "../tekstovi")'
