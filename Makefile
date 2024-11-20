# --- Settings ------------------------------------------
SOURCE_DIR = src
OUTPUT_DIR = docs

# --- Encryption Settings -------------------------------
ADMIN_FILE = admin.csv
ADMIN_PASSWORD = admin

# --- Encryption Password Settings ----------------------
PASSWORD_GEN_LENGTH = 4
PASSWORD_P1_GEN = $$(tr -dc 'a-z' < /dev/urandom | head -c$(PASSWORD_GEN_LENGTH))
PASSWORD_P2_GEN = $$(tr -dc '0-9' < /dev/urandom | head -c$(PASSWORD_GEN_LENGTH))
PASSWORD_GEN=$$(printf $(PASSWORD_P1_GEN)$(PASSWORD_P2_GEN))

# --- Pandoc Settings -----------------------------------
TEMPLATE = eisvogel.tex
PDF_ENGINE = xelatex
CSS = assets/css/style.css
PFLAGS=\
	  --listings -V fontsize=11pt\
	  --wrap=preserve
FILTERS=\
	  --lua-filter=filters/metamacros.lua\
	  --lua-filter=filters/baseroot.lua

# ------------------------------------------------------

SOURCES = $(shell find $(SOURCE_DIR) -name '*.md')
TARGETS = $(patsubst $(SOURCE_DIR)/%.md,$(OUTPUT_DIR)/%.pdf,$(SOURCES))
ENC_TARGETS = $(patsubst $(SOURCE_DIR)/%.md,$(OUTPUT_DIR)/%.pdf.enc,$(SOURCES))
ADMIN_ENC_TARGET=$(OUTPUT_DIR)/$(ADMIN_FILE).enc

# Check if we need to create new keys
NEW_KEYS ?= 0
PASSWORD_DEPENDENCY=
ifeq ($(NEW_KEYS),1)
PASSWORD_DEPENDENCY:=.FORCE
endif

# Encrypt Targets
all: $(TARGETS)

# Create the admin file
$(OUTPUT_DIR)/$(ADMIN_FILE):
	@{ \
		rm -f $@; \
		echo "KEY, TITLE, DATE" > $@; \
		printf "[   \x1b[93m*\x1b[0m  -> \x1b[32m.csv    \x1b[0m ] created admin file in \x1b[90m$(OUTPUT_DIR)/$(ADMIN_FILE)\x1b[0m\n"; \
	}

# Compile the markdown sources to pdf
$(OUTPUT_DIR)/%.pdf: $(SOURCE_DIR)/%.md $(CSS) Makefile
	@{\
		mkdir -p $(dir $@); \
		printf "[ \x1b[96m.md\x1b[0m  -> \x1b[33m.pdf\x1b[0m     ] Compiling \x1b[90m$<\x1b[0m into \x1b[90m$@\x1b[0m\n"; \
		pandoc $(PFLAGS) --to=pdf --pdf-engine=$(PDF_ENGINE) $(FILTERS) --css $(CSS) --template $(TEMPLATE) $< -o $@; \
	}

# Create the Key file
$(OUTPUT_DIR)/%.key.sh: $(PASSWORD_DEPENDENCY)
	@{ \
		echo "DOCUMENT_KEY=$(PASSWORD_GEN)" > $@; \
		printf "[   \x1b[93m*\x1b[0m  -> \x1b[92m.key.sh\x1b[0m  ] created encryption key in \x1b[90m$@\x1b[0m\n"; \
	}

# Encrypt the pdf files
$(OUTPUT_DIR)/%.pdf.enc: $(OUTPUT_DIR)/%.pdf $(OUTPUT_DIR)/%.key.sh $(OUTPUT_DIR)/$(ADMIN_FILE) $(PASSWORD_DEPENDENCY)
	@{ \
		src_path=$(subst $(OUTPUT_DIR),./$(SOURCE_DIR),$(<:.pdf=.md)); \
		key_path=$(<:.pdf=.key.sh); \
		key=$$(source $$key_path && echo $$DOCUMENT_KEY); \
		\
		printf "[ \x1b[33m.pdf\x1b[0m -> \x1b[92m.pdf.enc\x1b[0m ] Encrypting \x1b[90m$<\x1b[0m into \x1b[90m$@\x1b[0m\n"; \
		openssl enc -aes-256-cbc -salt -in $< -out $@ -pbkdf2 -iter 10000 -pass pass:$$key -base64 -A; \
		\
		title=$$(sed -n 's/^title: *//p' $$src_path); \
		date=$$(sed -n 's/^date: *//p' $$src_path); \
		\
		echo "$$key, $$title, $$date" >> $(OUTPUT_DIR)/$(ADMIN_FILE); \
	}

# Encrypt the csv files
$(ADMIN_ENC_TARGET): $(OUTPUT_DIR)/$(ADMIN_FILE)
	@{ \
		printf "[ \x1b[32m.csv\x1b[0m -> \x1b[92m.csv.enc\x1b[0m ] Encrypting Admin file \x1b[90m$<\x1b[0m into \x1b[90m$@\x1b[0m \n"; \
		openssl enc -aes-256-cbc -salt -in $< -out $@ -pbkdf2 -iter 10000 -pass pass:$(ADMIN_PASSWORD) -base64 -A; \
	}

# Encrypt Targets
encrypt: $(ENC_TARGETS) $(ADMIN_ENC_TARGET) Makefile
ifdef DEST
	@{ \
		rm -rf $(DEST)/$(OUTPUT_DIR); \
		cp -r $(OUTPUT_DIR) $(DEST)/$(OUTPUT_DIR); \
		echo "Deployed to $(DEST)/$(OUTPUT_DIR)"; \
	}
endif

# Clean the generated files
clean:
	rm -rf ./docs/*

.FORCE:
.SECONDARY:
.PHONY: all clean encrypt deploy .FORCE