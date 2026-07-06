# frozen_string_literal: true
#
# LOCAL-BUILD-ONLY compatibility shim, preloaded via RUBYOPT from the Makefile.
#
# GitHub Pages builds this site server-side with Jekyll 3.9 on an older Ruby.
# Locally we run Homebrew Ruby 4.x, which removed several APIs that Jekyll 3.9
# and its pinned Liquid 4.0.3 still call. This file restores just enough of the
# removed surface for the exact GitHub Pages engine to render locally.
#
# It is loaded via `RUBYOPT=-r.../tools/ruby4-compat.rb` (see the Makefile), NOT
# through Jekyll's _plugins/ mechanism — the github-pages gem forces Jekyll safe
# mode, which ignores _plugins/. Because RUBYOPT is set only by the Makefile,
# this shim never affects the GitHub Pages production build. Remove it once
# GitHub Pages (and this Gemfile) move to a Ruby-4-compatible Jekyll.

# Object taint was deprecated in Ruby 2.7 and REMOVED in Ruby 3.2, but Liquid
# 4.0.3's Liquid::Variable#taint_check still calls String#tainted?. Restore the
# removed methods as harmless no-ops so taint checking short-circuits.
unless Object.method_defined?(:tainted?)
  class Object
    def tainted? = false
    def taint = self
    def untaint = self
  end
end

# File.exists?/Dir.exists? were removed in Ruby 3.2; some older Jekyll code paths
# still call them. Alias back to the supported predicate.
File.singleton_class.alias_method(:exists?, :exist?) unless File.respond_to?(:exists?)
Dir.singleton_class.alias_method(:exists?, :exist?)  unless Dir.respond_to?(:exists?)
