#
# Makefile for acmart package
#
# This file is in public domain
#

PACKAGE=acmart

ASSIGNMENT = 4
GROUP = 12

PDF = INFOMSCIP-${ASSIGNMENT}-${GROUP}.pdf


all:  ${PDF}

%.pdf:  %.dtx   $(PACKAGE).cls
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done

%.pdf:  %.tex   $(PACKAGE).cls
	pdflatex $<
	- bibtex $*
	pdflatex $<
	while ( grep -qE '^(LaTeX Warning: Label\(s\) may have changed|Package natbib Warning: (Citation\(s\) may have changed))' $*.log) \
	do pdflatex $<; done

INFOMSCIP-%.pdf: main.pdf
	cp $< $@


acmguide.pdf: $(PACKAGE).dtx $(PACKAGE).cls
	pdflatex -jobname acmguide $(PACKAGE).dtx
	- bibtex acmguide
	pdflatex -jobname acmguide $(PACKAGE).dtx
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' acmguide.log) \
	do pdflatex -jobname acmguide $(PACKAGE).dtx; done

%.cls:   %.ins %.dtx
	pdflatex $<


tagged:
	${MAKE} acmart.cls && cd samples && ${MAKE} acmsmall-tagged.pdf && ${MAKE} sigconf-tagged.pdf




.PRECIOUS:  $(PACKAGE).cfg $(PACKAGE).cls $(PACKAGE)-tagged.cls

docclean:
	$(RM)  *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls *.cut *.hd \
	*.dvi *.ps *.thm *.tgz *.zip *.rpi


clean: docclean
	$(RM)  $(PACKAGE).cls $(PACKAGE)-tagged.cls 

distclean: clean
	$(RM)  *.pdf 

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	COPYFILE_DISABLE=1 tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' --exclude '*.tgz' --exclude '*.zip'  --exclude CVS --exclude '.git*' --exclude LICENSE $(PACKAGE); mv ../$(PACKAGE).tgz .

# distros
distros: all docclean
	zip -r acm-distro.zip  \
	acmart.pdf acmguide.pdf samples *.cls ACM-Reference-Format.* LICENSE \
	--exclude samples/sample-acmengage*
	zip -r acmengage-distro.zip samples/sample-acmengage* LICENSE \
	samples/*.bib \
	acmart.pdf acmguide.pdf  *.cls ACM-Reference-Format.*

acmcp.zip: all acmart.cls
	zip $@ $+

