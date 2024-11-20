CSS = pandoc.css
TEMPLATE = eisvogel.tex
SOURCE_DIR = ./src
OUTPUT_DIR = ./docs
PDF_ENGINE = weasyprint
FILTERS = filters

OPTIONS=fontsize=12pt

PFLAGS=--to=pdf\
	  --css $(CSS)\
	  --wrap=preserve\
	  --template $(TEMPLATE)\
	  --listings -V $(OPTIONS)\
	  --lua-filter=$(FILTERS)/metamacros.lua\
	  --lua-filter=$(FILTERS)/baseroot.lua

# List of all source md files, including subdirectories
SOURCES = $(shell find $(SOURCE_DIR) -name '*.md')

# Target PDF files maintaining directory structure
DEBUG_TARGETS = $(patsubst $(SOURCE_DIR)/%.md,$(OUTPUT_DIR)/%.md,$(SOURCES))
TARGETS = $(patsubst $(SOURCE_DIR)/%.md,$(OUTPUT_DIR)/%.pdf,$(SOURCES))

# Default rule
all: $(TARGETS) $(DEBUG_TARGETS)

# Rule for building PDFs
$(OUTPUT_DIR)/%.pdf: $(SOURCE_DIR)/%.md $(CSS) Makefile
	@mkdir -p $(dir $@)
	pandoc $(PFLAGS) $< -o $@

# Rule for building debug MD files
$(OUTPUT_DIR)/%.md: $(SOURCE_DIR)/%.md $(CSS) Makefile
	@mkdir -p $(dir $@)
	pandoc $(PFLAGS) -t markdown $< -o $@

# Clean rule
clean:
	rm -f $(OUTPUT_DIR)/*.pdf
	rm -f $(OUTPUT_DIR)/**/*.pdf

.PHONY: all clean