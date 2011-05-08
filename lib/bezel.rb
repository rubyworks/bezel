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
# How does this work? When you call lib(), Bezel looks for
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
# Despite these necessary practices for its use, Bezel is highly advantageous
# to the developers and end-users alike in that it puts an end to the dreaded
# Dependency Hell.
#
# TODO: Consider how best to support alternate loadpaths beyond 'lib/'.

class Bezel < Module
  # Cache of loaded modules. This speeds things
  # up if two libraries load the same third library.
  TABLE = Hash.new{|h,k|h[k]={}}

  # Load stack keeps track of what modules are in the process
  # of being loaded.
  STACK = []

  # Load library into a module namespace.
  def self.lib(name, version=nil)
    path = find(name, version)
    main = File.join(path, 'lib', name + '.rb')

    return TABLE[main] if TABLE.key?(main)

    mod = new(name, version, path)
    STACK.push mod
    mod.module_eval(File.read(main), main, 0)
    STACK.pop
    TABLE[main] = mod
  end

  #
  def self.import(fname)
    mod = STACK.last
    file = File.join(mod.__path__, 'lib', mod.__name__, fname)
    mod.module_eval(File.read(file), file, 0)
  end

  #
  #def self.main(name, version=nil)
  #  path = find(name, version)
  #  File.join(path, 'lib', name + '.rb')
  #end

  #
  def self.find(name, version=nil)
    path = nil
    path ||= gem_find(name, version)  if defined?(::Gem)
    path ||= roll_find(name, version) if defined?(::Roll)
    path
  end

  #
  def self.gem_find(name, version)
    raise ArgumentError, "version must be explicit" unless version

    basename = "#{name}-#{version}"
    gem_paths.find do |path|
      File.basename(path) == basename
    end
  end

  #
  def self.gem_paths
    @gem_paths ||= (
      Gem.path.map do |dir|
        Dir[File.join(dir, 'gems', '*')]
      end.flatten
    )
  end

  # TODO: Add Roll finder.
  def self.roll_find(name,version=nil)
    return nil
  end

  # Construct new Bezel module.
  def initialize(name, version, path)
    @__name__ = name
    @__vers__ = version
    @__path__ = path
    super()
  end

  # Name of library.
  def __name__
    @__name__
  end

  # Version of library.
  def __vers__
    @__vers__
  end

  # Path to library.
  def __path__
    @__path__
  end

end

# Retuns a new Bezel Module.
def lib(name, version=nil)
  Bezel.lib(name, version)
end

# When using Bezel, rather than use #require or #load, you use #import.
def import(fname)
  Bezel.import(fname)
end
