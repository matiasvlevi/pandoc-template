CSS = pandoc.css
TEMPLATE = eisvogel.tex
SOURCE_DIR = ./src
OUTPUT_DIR = ./docs
PDF_ENGINE = xelatex
FILTERS = filters

OPTIONS=fontsize=12pt

PFLAGS=--to=pdf\
	  --pdf-engine=$(PDF_ENGINE)\
	  --css $(CSS)\
	  --wrap=preserve\
	  --template $(TEMPLATE)\
	  --listings -V $(OPTIONS)\
	  --lua-filter=$(FILTERS)/metamacros.lua\
	  --lua-filter=$(FILTERS)/baseroot.lua

# List of source md files
SOURCES = $(wildcard $(SOURCE_DIR)/*.md)

# Target PDF files
TARGETS = $(patsubst $(SOURCE_DIR)/%.md,$(OUTPUT_DIR)/%.pdf,$(SOURCES))

# Default rule
all: $(TARGETS)

# Rule for building PDFs
$(OUTPUT_DIR)/%.pdf: $(SOURCE_DIR)/%.md $(CSS) Makefile
	@mkdir -p $(OUTPUT_DIR)
	pandoc $(PFLAGS) $< -o $@

# Clean rule
clean:
	rm -f $(OUTPUT_DIR)/*.pdf

.PHONY: all clean