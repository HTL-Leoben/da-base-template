# Where are the 
SOURCEDIR=./example
STYLEDIR=$(CURDIR)/style
STAGINGDIR=$(CURDIR)/staging

INPUTDIR=$(STAGINGDIR)
OUTPUTDIR=$(SOURCEDIR)/out

BIBFILE = literatur.bib
METADATAFILE = metadata.yaml
OUTPUTFILE = $(OUTPUTDIR)/diplomarbeit.pdf
LOGFILE = $(OUTPUTFILE).log
SPELLERRORFILE = $(OUTPUTDIR)/spellcheck-results.txt
TEMPLATENAME = da-base-template

SHELL := /bin/bash

help:
	@echo ' 								                                   '
	@echo 'Makefile für Pandoc Markdown Vorlage                                '
	@echo 'für Diplomarbeiten der HTL Leoben                                   '
	@echo ' 								                                   '
	@echo 'Autor: Günther Hutter, Clemens Lauermann und Andreas Pötscher       '
	@echo '       basierend auf der Arbeit von Michael Heinemann               '
	@echo '       sowie auf dem Template der HTL Rennweg3                      '
	@echo ' 								                                   '
	@echo 'Änderungswünsche werden ausschließlich via issue und pullrequest    '
	@echo 'Usage:                                                              '
	@echo '   make pdf                   generate a PDF file  	               '
	@echo '   make spellcheck            checks the output for misspelled words'
	@echo '                                                                    '
	@echo ' 																	

# Helper Targets
build-stage:
    # Kopieren der DA-Quellen in das staging Verzeichnis
	@echo "Source directory = $(SOURCEDIR)"
	@echo "Copying source files into the staging directory"
	@rsync -av $(SOURCEDIR)/ $(STAGINGDIR) \
	--cvs-exclude \
	--exclude=$(TEMPLATENAME) \
	--exclude=$(OUTPUTFILE) \
	--exclude=$(LOGFILE) \
	--quiet

    # Style in das staging Verzeichnis mergen
	@echo "Merging style files into the staging directory"
	@rsync -av $(STYLEDIR)/ $(STAGINGDIR)/style --quiet

    # Prüfen auf Dateien mit Unterstrichen im Namen
	@echo "Checking for files containing underscores in $(STAGINGDIR)..."
	@files=$$(find $(STAGINGDIR) -type f -name '*_*'); \
	if [ -n "$$files" ]; then \
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"; \
		echo "WARNING: Found files with underscores:"; \
		echo " ->  $$files"; \
		echo "These files are very likely to cause issues during the build process"; \
		echo "Remove or rename them to build the thesis safely"; \
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"; \
	fi

compile-output:
    # Bauen der Arbeit aus dem staging verzeichnis heraus
	@echo "Compiling the thesis into: $(OUTPUTFILE)"

    # Builden mit pandoc. Als Basisverzeichnis springen wir ins staging. 
    # Damit sollten alle relativen Links stimmen
	-@cd "$(STAGINGDIR)" && pandoc *.md style/*.md *.yaml \
	-o "$(OUTPUTFILE)" \
	--template="style/template.tex" \
    --bibliography="$(BIBFILE)" 2>"$(LOGFILE)" \
	--csl="style/htlle-diplomarbeit.csl" \
	--citeproc \
	--highlight-style=pygments \
	--listings \
	--metadata link-citations=true \
	-N 

    # Ausgabe der Warnungen 
	@cat $(LOGFILE)

    # Build erfolgreich -> Resultate zurückkopieren
	@rsync -az $(LOGFILE) $(OUTPUTDIR)/
	@rsync -az $(OUTPUTFILE) $(OUTPUTDIR)/
	
do-spellcheck:
	@echo "Performing a spellcheck on all Markdown files"

    # Überprüft die staging Dateien auf Rechtschreibfehler
	@hunspell -d de_AT,de_AT_frami,en_US -u3 -t "$(STAGINGDIR)"/*.md > "$(SPELLERRORFILE)"

    # Ausgabe der Rechtschreibfehler
	@echo '-------------------8<-------------------------'
    # @cat "$(SPELLERRORFILE)" | sort | uniq | sed 's/^/   /'
	@for file in $(STAGINGDIR)/*.md; do echo "Working on $$file..."; done
	@echo '------------------->8-------------------------'

    # Spell resultate zurueckkopieren
	@rsync -az $(SPELLERRORFILE) $(OUTPUTDIR)/

remove-stage:
    #Remove the staging directory
	@echo "Removing the staging directory"
	@rm -rf $(STAGINGDIR)

prepare-dirs:
	@mkdir -p "$(STAGINGDIR)"
	@mkdir -p "$(OUTPUTDIR)"

# Targets which are intended to be used directly
spellcheck: prepare-dirs build-stage do-spellcheck remove-stage

# Erzeugen einer PDF Datei
pdf: prepare-dirs build-stage compile-output remove-stage

# Ziel für die Erzeugung einer .tex Datei
tex: OUTPUTFILE := $(OUTPUTFILE).tex
tex: prepare-dirs build-stage compile-output remove-stage
 
clean-stage: 
    # Remove the staging directory
	@rm -rf $(STAGINGDIR)
clean-out: 
    # Remove the output directory
	@rm -rf $(OUTPUTDIR)
clean-all: clean-stage clean-out

# Special Targets
.PHONY: help pdf spellcheck tex clean-stage clean-out clean-all
