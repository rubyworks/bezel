# Bezel

## DESCRIPTION

The idea of Bezel is to overcome the limitations of using different
versions of the same package in the same Ruby process.


## RESOURCES

* home: http://proutils.github.com/bezel
* work: http://github.com/proutils/bezel
* mail: http://googlegroups.com/group/rubyworks-mailinglist


## USAGE

It works like this. Let's say I wrote a library called TomsLib. Now I
want to use TomsLib in my new fancy app, FancyApp. In my FancyApp
namespace I have to create a reference to TomsLib.

     module FancyApp
       TomsLib = lib('tomslib', '1.5')
       ...
 
Now I have access to TomsLib, but it is localized to my application.
If Jane comes along and wants to use a different version of TomsLib
but also utilizes my FancyApp, she could do so:

     module JanesProgram
       TomsLib  = lib('tomslib', '1.0')
       FancyApp = lib('fancyapp')  # use newest available
       ...

How does this work? When you call lib(), Bezel looks for the package
in the current Gem paths (and in the future, Roll ledger) then it
reads the primary package file (eg. tomslib.rb) from the package and
evals it into an anonymous module.

This has a some important effects on how you write your Ruby programs:

1. Any reference to core/standard libraries must be referenced via '::' 
prefix (eg. ::Enumerable).

2. Core extensions are not version isolated. So avoid them when
possible, or depend on highly stable standardized bases such as
Ruby Facets and ActiveSupport.

3. Since Bezel is a completely different alternative to Ruby's normal
load system, your program will require Bezel be installed by your
users. 

4. Within Bezel dependent libraries #import must be used instead
of #require or #load in order to keep the code within the current module.

Despite the minor limitations and necessary practices required for its
use, Bezel is highly advantageous to the developers and end-users alike
in that it puts an end to the dreaded Dependency Hell.

## COPYRIGHT

Copyright (c) 2009 Thomas Sawyer

Bezel is distributed under the terms of the Ruby License.
