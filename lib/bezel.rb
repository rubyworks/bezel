# The idea of Bezel is to overcome the limitations of using
# different versions of the same package in the same Ruby
# proccess.
#
# It works like this. Let's say I wrote a library called TomsLib.
# Now I want to use TomsLib in my new fancy app, FancyApp. In my
# FancyApp namespace I have to create a reference to TomsLib.
#
#   module FancyApp
#     TomsLib = lib('tomslib', '1.5')
#     ...
# 
# Now I have access to TomsLib, but it is localized to my
# application. If Jane comes along and wants to use a different
# version of TomsLib but also utilizes my FancyApp, she
# could do so:
#
#   module JanesProgram
#     TomsLib  = lib('tomslib', '1.0')
#     FancyApp = lib('fancyapp')  # use newest available
#     ...
#
# How does this work? When you call library(), Bezel looks for
# the package in the current gem paths (and, in the future, Roll ledger)
# then it reads the primary package file (eg. tomslib.rb) fro the package
# and evals it into an anonymous module.
#
# This has a some important effects on how you write your Ruby programs:
#
# 1. Any reference to core/standard libraries must be referenced via
#    :: prefix (eg. ::Enumerable).
#
# 2. Core extensions are not version controlled. So avoid them when
#    possible, or depend on highly stable standardized bases such as
#    Facets and ActiveSupport.
#
# 3. Since Bezel is a completely different alternative to Ruby's normal
#    load system, your program will require Bezel be installed by your
#    users. 
#
# Despite the limitations and necessary practices required for its use
# Bezel is highly advantageous to the developers and end-users alike
# in that it puts an end to the dreaded Dependency Hell.
#
class Bezel < Module
  require 'rubygems'

  # Cache of loaded modules. This speeds things
  # up if two libraries load the same third library.
  TABLE = Hash.new{|h,k|h[k]={}}

  # Load stack keeps track of what modules are in the process
  # of being loaded.
  STACK = []

  #
  def self.gem_paths
    @gem_paths ||= (
      Gem.path.map do |dir|
        Dir[File.join(dir, 'gems', '*')]
      end.flatten
    )
  end

  #
  def self.select(name)
    gem_paths.select do |path|
      File.basename(path) =~ /^#{name}-/
    end
  end

  #
  def self.find(name, version=nil)
    if version
      basename = "#{name}-#{version}"
      select(name).find do |path|
        File.basename(path) == basename
      end
    else
      select(name).max
    end
  end

  #
  #def self.main(name, version=nil)
  #  path = find(name, version)
  #  File.join(path, 'lib', name + '.rb')
  #end

  #
  def initialize(name, path)
    @__name__ = name
    @__path__ = path
  end

  def __name__
    @__name__
  end

  def __path__
    @__path__
  end

end

#
def lib(name, version=nil)
  path = Bezel.find(name, version)
  main = File.join(path, 'lib', name + '.rb')

  return Bezel::TABLE[main] if Bezel::TABLE.key?(main)

  mod = Bezel.new(name, path)

  Bezel::STACK << mod

  mod.module_eval(File.read(main), main, 0)

  Bezel::STACK.pop

  Bezel::TABLE[main] = mod
end

# When using Bezel, rather than use #require or #load, you use #import.
def import(fname)
  mod = Bezel::STACK.last
  file = File.join(mod.__path__, 'lib', mod.__name__, fname)
  mod.module_eval(File.read(file), file, 0)
end

