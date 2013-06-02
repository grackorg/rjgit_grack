Gem::Specification.new do |s|
  s.name = 'rjgit_grack'
  s.version = '0.1.1'
  s.date = '2013-06-02'
  s.summary = "Adapts grack (http://github.com/schacon/grack) to use JGit."
  s.description = "Alternative Adapter for grack; uses the RJGit gem for a pure jruby interface to git repos. Together with Grack, this yields a pure jruby implementation of git's smart-http protocol."
  s.authors = ['Dawa Ometto']
  s.email = 'd.ometto@gmail.com'
  s.files = ['rjgit_grack.rb', 'lib/rjgit_adapter.rb', 'README.md', 'LICENSE', 'Gemfile']
  s.homepage = "http://github.com/dometto/rjgit_grack"
  s.license = 'MIT'

  s.add_dependency('rjgit')
end
