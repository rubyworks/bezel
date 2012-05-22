---
source:
- meta
authors:
- name: trans
  email: transfire@gmail.com
copyrights:
- holder: Rubyworks
  year: '2010'
  license: BSD-2-Clause
requirements:
- name: detroit
  groups:
  - build
  development: true
- name: qed
  groups:
  - test
  development: true
- name: ae
  groups:
  - test
  development: true
- name: ansi
  version: 1.4.2
  groups:
  - test
  development: true
dependencies: []
alternatives: []
conflicts: []
repositories:
- uri: git://github.com/proutils/bezel.git
  scm: git
  name: upstream
resources:
- uri: http://rubyworks.github.com/bezel
  label: Website
  type: home
- uri: http://github.com/rubyworks/bezel
  label: Source Code
  type: code
- uri: http://github.com/rubyworks/bezel/issues
  label: Issue Tracker
  type: bugs
- uri: http://groups.google.com/groups/rubyworks-mailinglist
  label: Mailing List
  type: mail
- uri: irc://us.chat.freenode.net/rubyworks
  label: IRC Channel
  type: chat
categories: []
extra: {}
load_path:
- lib
revision: 0
name: bezel
title: Bezel
organization: Rubyworks
created: '2010-02-19'
summary: Alternate loading system for Ruby allowing version multiplicity.
version: 0.2.0
description: Alternate loading system for Ruby allowing version multiplicity.
date: '2012-05-22'
