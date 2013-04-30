rjgit_grack
===========

Alternative Adapter for [grack](http://github.com/schacon/grack); uses the [RJGit](http://github.com/repotag/rjgit) gem for a pure jruby interface to git repo's. Together with Grack, this yields a pure jruby implementation of git's smart-http protocol.

Usage
===========

1. Get grack.
2. After requiring rjgit_adapter.rb, you can tell Grack to use the RJGitAdapter by editing its configuration, like so:

```ruby
config = {
  :adapter => Grack::RJGitAdapter,
  :upload_pack => true,
  :receive_pack => true,
}
```

Dependencies
===========

- [Grack](http://github.com/schacon/grack)
- The [RJGit](http://github.com/repotag/rjgit) gem

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
