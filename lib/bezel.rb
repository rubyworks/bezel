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
# How does this work? When you call lib(), Bezel looks for the
# package in the current gem paths (and, in the future, Roll ledger)
# then it reads the bezel file (e.g. lib/tomslib.rbz) from the package
# and evals it into an anonymous module.
#
# This has a some important effects on how you write your Ruby programs:
#
# 1. Any reference to core/standard libraries must be referenced via
#    toplevel `::` prefix (eg. ::Enumerable).
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
# to developers and end-users alike in that it puts an end to the dreaded
# Dependency Hell.
#
# TODO: Consider how best to support alternate loadpaths beyond 'lib/'.

class Bezel < Module
  # Cache of loaded modules. This speeds things
  # up if two libraries load the same third library.
  TABLE = Hash.new #{|h,k|h[k]={}}

  # Script cache.
  SCRIPT = {}

  # Load stack keeps track of what modules are in the process
  # of being loaded.
  STACK = []

  # Load library into a module namespace.
  def self.lib(name, version=nil)
    path = find(name, version)
    ## load error if no gem found
    raise LoadError, "#{name}-#{version} not found" unless path
    ## location of bezel file (*.rbz).
    main = File.join(path, 'lib', name + '.rb')  #.rbz #TODO: LOADPATH
    ## check cache
    return TABLE[main] if TABLE.key?(main)
    ## load error if no bezel file
    raise LoadError, "#{name}-#{version} has no bezel!" unless File.exist?(main)
    ## read in bezel file
    #script = File.read(main)
    # create new Bezel module for file
    mod = new(name, version, path)
    ## put module on STACK
    STACK.push mod
    ## evaluate script in the context of module
    #mod.module_eval(script, main, 0)  # r =
    mod.__load_feature__(main)
    ## pop module off STACK
    STACK.pop
    ## add module to cache, and return module
    TABLE[main] = mod
    # if Module === r ? r : mod
  end

=begin
  #
  def self.import(fname)
    ## lookup most recent Bezel module
    current = STACK.last
    ## if Bezel module is returned
    if current
      current.__load_feature__(fname)
    else ## if no Bezel module is returned
      ## fallback to regular require
      require_without_bezel(fname)
    end
  end
=end

  #
  def self.require(path)
    if current = STACK.last
      begin
        current.__load_feature__(path) ? true : false
      rescue LoadError
        require_without_bezel(path)
      end
    else
      require_without_bezel(path)
    end
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
    @__name__     = name
    @__version__  = version
    @__path__     = path
    @__features__ = []
    super()
  end

  # Name of library.
  def __name__
    @__name__
  end

  # Version of library.
  def __version__
    @__version__
  end

  # Path to library.
  def __path__
    @__path__
  end

  #
  def __features__
    @__features__
  end

  #
  def __load_feature__(path)
    if path =~ /^[\.\/]/  # if absolute path
      file = File.expand_path(path)
    else
      glob = File.join(__path__, 'lib', path + "{.rb,}")  # TODO: All possible extensions
      file = Dir[glob].first
    end

    raise LoadError, "no such file to load -- #{file}" unless file

    if __features__.include?(file)
      return false
    else
      __features__ << file
      script = File.read(file) #(SCRIPT[file] ||= File.read(file))
      module_eval(script, file, 0)
    end

    return file
  end

end

# Retuns a new Bezel Module.
def lib(name, version=nil)
  Bezel.lib(name, version)
end

#
alias require_without_bezel require

# Override require to try bezel first.
def require(fname)
  Bezel.require(fname)
end

# TODO require_relative
#

## When using Bezel, rather than use #require or #load, you use #import.
#def import(fname)
#  Bezel.import(fname)
#end

