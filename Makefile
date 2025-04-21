.DEFAULT_GOAL := all

# Windows commands
ifeq ($(OS),Windows_NT)
	COPY_COMMAND := copy
	RM_COMMAND   := powershell -Command "Remove-Item -Recurse"
	MOVE_COMMAND := move /Y
	SEP := \\
# Unix-like commands
else
	COPY_COMMAND := cp
	RM_COMMAND   := rm -r
	MOVE_COMMAND := mv
	SEP := /
endif

# Source files
ifeq ($(OS),Windows_NT)
	SOURCES     := $(powershell -Command "Get-ChildItem -Recurse -Filter *.tex | Where-Object { $_.FullName -notlike '*\\Verzeichnisse\\*' } | ForEach-Object { $_.FullName }")  # Document sources (Windows)
	INDICES     := $(powershell -Command "Get-ChildItem -Recurse -Filter *.tex -Path .\Verzeichnisse | ForEach-Object { $_.FullName }")                                          # Index files (Windows)
else
	SOURCES     := $(shell find . -name '*.tex' -not -path './Verzeichnisse/*')  # Document sources (Unix-like)
	INDICES     := $(shell find ./Verzeichnisse -name '*.tex')                   # Index files (Unix-like)
endif
# Bibliography
BIBLIOGRAPHY  := Verzeichnisse/Literaturverzeichnis.bib
# Glossary
GLOSSARY      := Verzeichnisse/Glossar.tex

NAME          := Arbeit
BUILD_DIR     := .build
ARGS_PDFLATEX := -output-directory=$(BUILD_DIR)

# Generate build directory (including child directories) if non-existant
$(BUILD_DIR):
ifeq ($(OS),Windows_NT)
	powershell -Command "Get-ChildItem -Directory -Exclude '.*' | ForEach-Object { New-Item -ItemType Directory -Force -Path "${BUILD_DIR}" -Name $$_.Name }"
else
	@for DIR in $(shell find . -maxdepth 1 -mindepth 1 -type d -not -name '.*' -exec basename '{}' \;); do \
		mkdir -p ${BUILD_DIR}/$$DIR; \
	done
endif

$(NAME).pdf: $(BUILD_DIR) $(SOURCES)
	pdflatex $(ARGS_PDFLATEX) $(NAME)
	$(COPY_COMMAND) $(BIBLIOGRAPHY) $(BUILD_DIR)$(SEP)$(BIBLIOGRAPHY)
	-cd $(BUILD_DIR) && bibtex $(NAME)
	-cd $(BUILD_DIR) && makeglossaries $(NAME)
	-cd $(BUILD_DIR) && makeindex $(NAME).nlo -s nomencl.ist -o $(NAME).nls
	pdflatex $(ARGS_PDFLATEX) $(NAME)
	pdflatex $(ARGS_PDFLATEX) $(NAME)
	@$(MOVE_COMMAND) $(BUILD_DIR)$(SEP)$(NAME).pdf .

.PHONY: clean
clean:
	$(RM_COMMAND) $(BUILD_DIR)

.PHONY: all
all: $(NAME).pdf

.PHONY: full
full: all clean
