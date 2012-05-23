# Bezel


## DESCRIPTION

The idea of Bezel is to overcome the limitations of using different
versions of the same package in the same Ruby process.


## RESOURCES

* home: http://proutils.github.com/bezel
* work: http://github.com/proutils/bezel
* mail: http://googlegroups.com/group/rubyworks-mailinglist
* chat: irc://chat.us.freenode.net/rubyworks


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

2. Core extensions are not version isolated. So when possible, avoid them
or depend on highly stable standardized bases such as Ruby Facets
and ActiveSupport.

3. Since Bezel is a completely different alternative to Ruby's normal
load system, your program will require Bezel be installed by your
users. No big deal. In other words, list it into your projects dependencies.

4. A project's main require file must be the same as the library's name.

Despite these necessary practices for its use, Bezel is highly advantageous
to the developers and end-users alike in that it puts an *absolute* end to
the dreaded *Dependency Hell*.


## STATUS

It may not be possible to test Bezel via Travis CI because of the way the tests
change the GEM_HOME. Currently they fail because of this, even though they pass
on local development machine. We'll leave this for now in hopes we will get it
working at some point: 
[![Build Status](https://secure.travis-ci.org/rubyworks/bezel.png)](http://travis-ci.org/rubyworks/bezel)


## LICENSE

Copyright (c) 2009 Thomas Sawyer

Bezel is distributed under the same terms as Ruby 1.9+, namely the 
BSD 2-clause license.
