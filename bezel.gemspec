Gem::Specification.new do |s|
  s.name        = 'bezel'
  s.version     = '0.2.0'
  s.summary     = 'Alternate loading system for Ruby allowing version multiplicity.'
  s.description = 'Bezel is a load manager for Ruby which allows for version multiplicity.'

  s.authors     = ['Trans']
  s.email       = ['transfire@gmail.com']

  s.homepage    = 'https://github.com/rubyworks/bezel'
  s.license     = 'BSD-2-Clause'

  s.files       = Dir['lib/**/*', 'LICENSE.txt', 'README.md', 'HISTORY.md', 'demo/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'finder', '~> 0.3'
end
