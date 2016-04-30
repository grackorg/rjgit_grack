rjgit_grack
===========
[![Gem Version](https://badge.fury.io/rb/rjgit_grack.svg)](http://badge.fury.io/rb/rjgit_grack)
[![Build Status](https://travis-ci.org/grackorg/rjgit_grack.svg?branch=master)](https://travis-ci.org/grackorg/rjgit_grack.svg?branch=master)
[![Dependency Status](https://gemnasium.com/dometto/rjgit_grack.svg)](https://gemnasium.com/grackorg/rjgit_grack)

Alternative Adapter for [grack](http://github.com/grackorg/grack); uses the [RJGit](http://github.com/repotag/rjgit) gem for a pure jruby interface to git repos. Together with Grack, this yields a pure jruby implementation of git's smart-http protocol.

Installation
===========

 `gem install rjgit_grack`

Usage
===========

1. Get [grack](https://github.com/grackorgs/grack).
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

Hooks
===========

This adapter allows you to specify hooks to be called when receive operations (i.e. `git push` to the server) or upload operations (e.g. pulls, clones) are initiated. You can easily do this by passing an options hash to the `Grack::RJGitAdapter.new` call in the configuration, like so:

```ruby
  :git_adapter_factory => ->{ Grack::RJGitAdapter.new({
    :preReceive => Proc.new do |received_refs|
      # This code is executed in the hook
      puts received_refs
    end
    }
  )}
```

You can specify the following hooks:
  * `:preReceive` executed immediately before a receive-operation is performed. Yields an `Array` with `Hash` objects containing info about each ref that is about to be pushed, of the following form:
    ```ruby
      {:ref_name => 'refs/heads/masters', :old_id => 'somesha1', :new_id => 'someothersha1', :type => "FAST_FORWARD", :result => "OK"}
    ```
  * `:postReceive` executed after a receive-operation is completed. Yields an `Array` with `Hash` objects for each ref that was pushed, of the same form as above, plus a `:result` field. The result will be a `String`, and can have one of the values [defined by JGit](http://download.eclipse.org/jgit/site/4.3.0.201604071810-r/apidocs/index.html).
  * `:preReceive` executed immediately before an upload-operation is performed, i.e. before data is sent to the client. Yields an `Array` of `String` object-id's (SHA1-hashes) already in common between client and server.
  * `:postReceive` executed after an upload-operation to a client is complete. Returns an `org.eclipse.jgit.storage.pack.PackStatistics` object (see [here](http://download.eclipse.org/jgit/site/4.3.0.201604071810-r/apidocs/org/eclipse/jgit/storage/pack/PackStatistics.html)).

Note that JGit blocks all read and write operations on the repository until a hook is complete, so the hooks should only contain code that runs quickly (e.g. running workers or threads to perform the heavy work).

Specs
======

Run the specs:

`rake`

Dependencies
===========

- [Grack](http://github.com/grackorg/grack) >= 0.1.0.pre2
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
