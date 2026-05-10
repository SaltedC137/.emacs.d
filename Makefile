# compile.el - A Makefile for compiling Emacs Lisp files in the .emacs.d directory
#author: Sally Face (github/SaltedC137)
#date: 2026-04-30


EMACS ?= emacs
EMACS_DIR := $(CURDIR)
LISP_DIR := $(EMACS_DIR)/lisp
LOCAL_EL := $(EMACS_DIR)/early-init.el $(EMACS_DIR)/init.el $(wildcard $(LISP_DIR)/*.el)
NATIVE_COMP_AVAILABLE := $(shell $(EMACS) --batch -Q --eval "(condition-case nil (progn (require 'comp) (princ 1)) (error (princ 0)))" 2>/dev/null)

EMACS_BATCH_BASE = $(EMACS) --batch -Q \
	--eval "(setq user-emacs-directory (expand-file-name \"$(EMACS_DIR)/\"))" \
	--eval "(require 'package)" \
	--eval "(setq package-user-dir (expand-file-name \"elpa\" user-emacs-directory) package-quickstart-file (expand-file-name \"package-quickstart.el\" user-emacs-directory))" \
	--eval "(package-initialize)" \
	--eval "(add-to-list 'load-path (expand-file-name \"$(LISP_DIR)\"))" \
	--eval "(when (and (fboundp 'native-comp-available-p) (native-comp-available-p)) \
	         (setq package-native-compile t \
	               comp-deferred-compilation t \
	               native-comp-async-jobs-number 4 \
	               native-comp-async-report-warnings-errors nil) \
	         (add-to-list 'native-comp-eln-load-path (expand-file-name \"eln-cache\" user-emacs-directory)))"

.PHONY: help all compile compile-local compile-packages quickstart clean

help:
	@echo "Targets:"
	@echo "  make compile-local   # Byte-compile early-init.el, init.el and lisp/*.el"
	@echo "  make compile-packages # Recompile installed ELPA packages"
	@echo "  make quickstart      # Refresh package quickstart cache"
	@echo "  make compile         # compile-local + compile-packages + quickstart"
	@echo "  make clean           # Remove local compiled .elc files"

all: compile

compile: compile-local compile-packages quickstart

compile-local:
	@echo "compile .elc"
	$(EMACS_BATCH_BASE) -f batch-byte-compile $(LOCAL_EL)
	@if [ "$(NATIVE_COMP_AVAILABLE)" = "1" ]; then \
		echo "compile .eln"; \
		$(EMACS_BATCH_BASE) -f batch-native-compile $(LOCAL_EL); \
	else \
		echo "skip .eln (native compilation unavailable)"; \
	fi


compile-native:
	@if [ "$(NATIVE_COMP_AVAILABLE)" = "1" ]; then \
		$(EMACS_BATCH_BASE) -f batch-native-compile $(LOCAL_EL); \
	else \
		echo "Native compilation is unavailable in this Emacs build."; \
		exit 1; \
	fi

compile-packages:
	$(EMACS_BATCH_BASE) --eval "(package-recompile-all)"

quickstart:
	$(EMACS_BATCH_BASE) --eval "(package-quickstart-refresh)"

clean:
	@echo "Cleaning .elc and .eln files..."
	@find $(EMACS_DIR) -type f \( -name "*.elc" -o -name "*.eln" \) -delete
