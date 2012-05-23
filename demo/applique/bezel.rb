# require bezel

require 'bezel'

# use a dummy Gem location for this example

ENV['GEM_HOME'] = File.expand_path('../fixtures', File.dirname(__FILE__))

#p Gem::Specification.all_names

#Gem.path.unshift(File.expand_path('../fixtures', File.dirname(__FILE__)))
#puts "Gem path added: " + File.expand_path('fixtures', File.dirname(__FILE__))

