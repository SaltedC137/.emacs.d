# compile.el - A Makefile for compiling Emacs Lisp files in the .emacs.d directory
#author: Sally Face (github/SaltedC137)
#date: 2026-04-30


EMACS ?= emacs
EMACS_DIR := $(CURDIR)
LISP_DIR := $(EMACS_DIR)/lisp
LOCAL_EL := $(EMACS_DIR)/early-init.el $(EMACS_DIR)/init.el $(wildcard $(LISP_DIR)/*.el)

EMACS_BATCH_BASE = $(EMACS) --batch -Q \
	--eval "(setq user-emacs-directory (expand-file-name \"$(EMACS_DIR)/\"))" \
	--eval "(require 'package)" \
	--eval "(setq package-user-dir (expand-file-name \"elpa\" user-emacs-directory) package-quickstart-file (expand-file-name \"elpa/package-quickstart.el\" user-emacs-directory))" \
	--eval "(package-initialize)" \
	--eval "(add-to-list 'load-path (expand-file-name \"$(LISP_DIR)\"))"

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
	$(EMACS_BATCH_BASE) -f batch-byte-compile $(LOCAL_EL)

compile-packages:
	$(EMACS_BATCH_BASE) --eval "(package-recompile-all)"

quickstart:
	$(EMACS_BATCH_BASE) --eval "(package-quickstart-refresh)"

clean:
	rm -f $(EMACS_DIR)/early-init.elc $(EMACS_DIR)/init.elc $(LISP_DIR)/*.elc
