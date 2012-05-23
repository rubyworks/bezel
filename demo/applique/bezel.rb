# Use a dummy Gem location for this example.
dummy_gem_home = File.expand_path('../fixtures', File.dirname(__FILE__))

ENV['GEM_HOME'] = dummy_gem_home
Gem.path.unshift(dummy_gem_home)

Gem::Specification.reset

#p Gem::Specification.all_names
#puts "Gem path added: #{dummy_gem_home}"

# Require Bezel
require 'bezel'

