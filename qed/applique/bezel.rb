# require bezel

require 'bezel'

# use a dummy Gem location for this example

Gem.path.unshift(File.expand_path('../fixtures', File.dirname(__FILE__)))

puts "Gem path added: " + File.expand_path('fixtures', File.dirname(__FILE__))
