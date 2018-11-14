.PHONY: all

all: priprema_podaci_upitnik.R r_uvod.R

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
