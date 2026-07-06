# Makefile — local Jekyll development for the Spectra external marketing site.
#
# WHY THIS EXISTS
#   `which ruby` on this host is macOS system Ruby 2.6, which modern Jekyll can't
#   use. Homebrew Ruby 4.x is installed but keg-only (not on PATH), and the
#   global PATH is admin-locked — so we do NOT change it. Instead this Makefile
#   scopes Homebrew Ruby to THIS project only and installs every gem into
#   ./vendor/bundle (gitignored). Nothing here needs sudo, and nothing writes
#   outside the repo and your own ~/.local gem dir.
#
# USAGE
#   make install   # one-time: fetch Jekyll + GitHub Pages gems into ./vendor/bundle
#   make serve     # preview at http://127.0.0.1:4000  (Ctrl-C to stop)
#   make build     # build the site into ./_site (validation of the local build)
#   make css       # rebuild Tailwind CSS -> assets/css/main.css
#   make doctor    # show which ruby/bundler this project resolves to

# --- Toolchain, addressed by ABSOLUTE PATH ----------------------------------
# We call ruby/gem/bundle by full path on purpose. GNU Make 3.81 runs a bare,
# metacharacter-free recipe line by exec-ing it directly, and that direct exec
# searches Make's *startup* PATH — it ignores `export PATH :=` below. On this
# host the startup PATH has no Homebrew Ruby, so a bare `bundle` would resolve to
# system Ruby 2.6 and fail. Absolute paths sidestep the PATH search entirely.

# Keg-only Homebrew Ruby 4.x — deliberately never on the global PATH.
RUBY_BIN := /opt/homebrew/opt/ruby/bin
RUBY     := $(RUBY_BIN)/ruby
GEM      := $(RUBY_BIN)/gem

# Per-user gem bin dir (writable by you). We keep a clean, self-consistent
# Bundler here because the Homebrew *default* bundler on this host is internally
# version-skewed (its code and gemspec disagree). Resolved dynamically so this
# works for any user account, not just weenie-dev.
USER_GEM_BIN := $(shell $(RUBY) -e 'print Gem.user_dir' 2>/dev/null)/bin
BUNDLE       := $(USER_GEM_BIN)/bundle

# --- Environment exported to every recipe's subprocesses --------------------
# (Used by processes spawned *by* bundle/jekyll — e.g. git for github-metadata —
# not to resolve the top-level bundle, which is already absolute above.)
export PATH := $(USER_GEM_BIN):$(RUBY_BIN):$(PATH)

# This host starts recipes with no LANG/LC_ALL, so Ruby defaults its file
# encoding to US-ASCII and Jekyll dies on the first UTF-8 byte (em-dashes in the
# content, the bundled theme's SCSS, etc.). Force a UTF-8 locale for the build.
export LANG   := en_US.UTF-8
export LC_ALL := en_US.UTF-8

# Keep installed gems inside the repo (gitignored). This never touches the
# admin-owned system gem dir, which weenie-dev cannot write anyway.
export BUNDLE_PATH := vendor/bundle

# Preload a tiny compatibility shim into every Ruby process. Jekyll 3.9 (the
# engine GitHub Pages runs) predates Ruby 3.2/4.0 and calls a few APIs that Ruby
# removed (String#tainted?, File.exists?). The github-pages gem forces Jekyll
# safe mode, which ignores _plugins/, so we inject the shim at the interpreter
# level instead. Set ONLY here (local dev) — the GitHub Pages build is never
# affected. See tools/ruby4-compat.rb.
export RUBYOPT := -r$(CURDIR)/tools/ruby4-compat.rb

.PHONY: help doctor bundler install css serve build clean
.DEFAULT_GOAL := help

help:
	@grep -E '^#   make ' $(MAKEFILE_LIST) | sed 's/^#   /  /'

doctor:
	@echo "ruby:    $(RUBY)   ($$($(RUBY) --version))"
	@echo "gem:     $(GEM)   ($$($(GEM) --version))"
	@echo "bundler: $(BUNDLE)   ($$($(BUNDLE) --version 2>/dev/null || echo 'not yet installed — run make install'))"
	@echo "BUNDLE_PATH=$(BUNDLE_PATH)"

# Ensure a clean, self-consistent Bundler exists in the user gem dir. Idempotent
# (--conservative skips the install when a bundler is already present).
bundler:
	@$(GEM) install --user-install --conservative bundler >/dev/null \
		&& echo "bundler ready: $$($(BUNDLE) --version)"

install: bundler
	$(BUNDLE) install

css:
	npm run build:css

serve:
	$(BUNDLE) exec jekyll serve --host 127.0.0.1 --port 4000 --livereload

build:
	JEKYLL_ENV=production $(BUNDLE) exec jekyll build

clean:
	rm -rf _site .jekyll-cache
