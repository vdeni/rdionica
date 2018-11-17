.PHONY: all

all: ../docs/priprema_podaci_upitnik.html ../tekstovi/priprema_podaci_upitnik.pdf\
	../kod/priprema_podaci_upitnik.R\
	../docs/r_uvod.html ../tekstovi/r_uvod.pdf ../kod/r_uvod.R\
	../radne-biljeznice/priprema_podaci_upitnik.R\
	../radne-biljeznice/r_uvod.R ../docs/index.html\

../kod/%.R: %.ipynb
	jupytext -o $@ $<
	sed -e '/slidesh/d;/.*coding: utf.*/d' $@ > tmp.txt
	mv tmp.txt $@
	if [ $@ = '../kod/priprema_podaci_upitnik.R' ];\
	    then\
	    sed -Ef priprema_helper.sed $@ > tmp.txt;\
	    mv tmp.txt $@;\
	elif [ $@ = '../kod/r_uvod.R' ];\
	    then\
	    sed -Ef uvod_helper.sed $@ > tmp.txt;\
	    mv tmp.txt $@;\
	fi

../docs/%.R: ../kod/%.R
	cp $< $@

../docs/%.html: ../docs/%.R
	Rscript -e 'rmarkdown::render("$<", output_format = "html_document")'
	rm $<

../tekstovi/%.pdf: ../kod/%.R
	Rscript -e 'rmarkdown::render("$<", output_format = "pdf_document", output_dir = "../tekstovi")'

../radne-biljeznice/%.R: ../kod/%.R
	cp $< $@
	sed -f ../radne-biljeznice/prep.sed $@ > tmp.txt
	mv tmp.txt $@

../docs/index.html: ../docs/index.Rmd
	Rscript -e 'rmarkdown::render("$<")'
