rjgit_grack
===========
[![Gem Version](https://badge.fury.io/rb/rjgit_grack.svg)](http://badge.fury.io/rb/rjgit_grack)
[![Build Status](https://travis-ci.org/dometto/rjgit_grack.svg?branch=master)](https://travis-ci.org/grackorg/rjgit_grack)
[![Dependency Status](https://gemnasium.com/dometto/rjgit_grack.svg)](https://gemnasium.com/grackorg/rjgit_grack)

Alternative Adapter for [grack](http://github.com/grackorg/grack); uses the [RJGit](http://github.com/repotag/rjgit) gem for a pure jruby interface to git repos. Together with Grack, this yields a pure jruby implementation of git's smart-http protocol.

Installation
===========

 `gem install rjgit_grack`

Usage
===========

1. Get grack.
2. After requiring `rjgit_grack.rb`, you can tell Grack to use the `RJGitAdapter` by editing its configuration, for example:

```ruby
require 'grack/app'
require 'grack/git_adapter'
require 'rjgit_grack'

config = {
  :root => '/path/to/bare/repositories',
  :allow_push => true,
  :allow_pull => true,
  :git_adapter_factory => ->{ Grack::RJGitAdapter.new }
}

run Grack::App.new(config)
```

Specs
======

Run the specs:

`rake`

Dependencies
===========

- [Grack](http://github.com/grackorg/grack) >= 0.1.0.pre
- The [RJGit](http://github.com/repotag/rjgit) gem, which requires JRuby

License
========================
	(The MIT License)

	Copyright (c) 2013 Dawa Ometto <d.ometto@gmail.com>

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	'Software'), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
