require 'rubygems/package_task'

gemspec = Gem::Specification.load('bezel.gemspec')

Gem::PackageTask.new(gemspec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

task :default do
  puts "No tests configured."
end
