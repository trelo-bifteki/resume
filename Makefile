ICONS_SVG=$(wildcard assets/*_icon.svg)
ICONS_PDF=$(ICONS_SVG:.svg=.pdf)

all: class documentation

pictures: icons europasslogo2013.pdf

europasslogo2013.pdf: assets/europasslogo2013.svg
	inkscape $< --export-area-drawing --export-pdf $@

# convert from pdf to ps then back to pdf to avoid the pdftex warning "PDF
# inclusion: multiple pdfs with page group included in a single page"
icons: $(ICONS_SVG) $(ICONS_PDF)

%_europass_icon.pdf.temp : %_europass_icon.svg
	inkscape $< --export-area-page --export-pdf $@

%_europass_icon.ps : %_europass_icon.pdf.temp
	pdf2ps $< $@

%_europass_icon.pdf : %_europass_icon.ps
	ps2pdf $< $@

documentation: class resume-de-Lampros_Papadimitriou.pdf resume-en-Lampros_Papadimitriou.pdf

resume-de-Lampros_Papadimitriou.pdf: resume-de-Lampros_Papadimitriou.tex
	pdflatex $<
	pdflatex $<

resume-en-Lampros_Papadimitriou.pdf: resume-en-Lampros_Papadimitriou.tex
	pdflatex $<
	pdflatex $<

class: pictures

package: class documentation
	mkdir -p mypasscv/example
	cp *.svg mypasscv
	cp *_europass_icon.pdf mypasscv
	cp europasslogo2013.pdf mypasscv
	cp mypasscv.cls mypasscv
	cp mypasscv*.def mypasscv
	cp mypasscv.tex mypasscv
	cp mypasscv.pdf mypasscv
	cp mypasscv_en.tex mypasscv/example
	cp mypasscv_en.pdf mypasscv/example
	cp README mypasscv
	cp Makefile mypasscv/Makefile.mypasscv
	tar -cvf mypasscv.tar mypasscv
	gzip -f mypasscv.tar
	rm -fr mypasscv

distclean:
	rm -f *~ *.synctex.gz *.aux *.log *.out *.backup *.toc *.temp

cleanicons:
	rm -r assets/*.pdf

clean: distclean cleanicons
	rm -f *.pdf
