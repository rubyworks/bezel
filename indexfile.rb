#!/usr/bin/env ruby
# encoding: utf-8

name(
  "bezel"
)

version(
  "0.2.0"
)

title(
  "Bezel"
)

summary(
  "Alternate loading system for Ruby allowing version multiplicity."
)

description(
  "Bezel is a load manager for Ruby which allows " \
  "for version multiplicity."
)

requirements(
  "finder 0.3~",
  "detroit (build)",
  "qed (test)",
  "ae (test)",
  "ansi 1.4.2 (test)"
)

resources(
  "home" => "http://rubyworks.github.com/bezel",
  "code" => "http://github.com/rubyworks/bezel",
  "bugs" => "http://github.com/rubyworks/bezel/issues",
  "mail" => "http://groups.google.com/groups/rubyworks-mailinglist",
  "chat" => "irc://us.chat.freenode.net/rubyworks"
)

repositories(
  "upstream" => "git://github.com/proutils/bezel.git"
)

organizations(
  "Rubyworks"
)

authors(
  "trans <transfire@gmail.com>"
)

copyrights(
  "2010 Rubyworks (BSD-2-Clause)"
)

created "2010-02-19"

