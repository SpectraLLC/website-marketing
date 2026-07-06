# frozen_string_literal: true

# Local Jekyll toolchain for the Spectra external marketing site.
#
# GitHub Pages builds this site server-side from a fixed, curated set of gem
# versions bundled in the `github-pages` gem. Depending on that gem (rather than
# on `jekyll` directly) makes a local `bundle exec jekyll serve` match the
# production build as closely as possible: the same Jekyll engine (3.9.x), the
# same Markdown processor (kramdown), and the same plugin allowlist.
#
# Current deployed versions: https://pages.github.com/versions/
#
# NOTE: this host runs Homebrew Ruby 4.x. Bundler resolves `github-pages` to the
# newest release whose ENTIRE dependency tree still supports Ruby 4, so the
# pinned version may trail the very latest GitHub Pages release. The Jekyll
# engine (3.9.x) is identical either way, so rendered output matches for this
# Tailwind-based site. See the Makefile for how Ruby is scoped to this project.

source "https://rubygems.org"

# Pins the whole build toolchain to GitHub Pages. Grouped under :jekyll_plugins
# so Jekyll auto-requires the plugins github-pages enables.
gem "github-pages", group: :jekyll_plugins

# Ruby 3.0+ dropped webrick from the standard library, but Jekyll's built-in
# preview server (`jekyll serve`) still needs it. Ignored by GitHub Pages.
gem "webrick", "~> 1.8"

# Jekyll 3.9 (the engine GitHub Pages runs) predates Ruby 3.4/4.0, which removed
# these libraries from the default gems. Without them, `require "csv"` etc. fail
# under Homebrew Ruby 4.x. Declaring them here restores the old behavior locally;
# GitHub Pages' own (older) Ruby already bundles them, so these are inert there.
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"

# Site-specific Jekyll plugins go here. GitHub Pages only runs plugins on its
# allowlist (see the versions page above); anything else builds locally but is
# skipped when GitHub Pages builds the deployed site.
group :jekyll_plugins do
  # gem "jekyll-feed"  # example — already provided transitively by github-pages
end
