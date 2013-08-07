task :default => :test
 
desc "Run the tests."
task :test do
  rename_test_git_dir
  Dir.glob("tests/*_test.rb").each do |file|
        require "./#{file}"
  end
end

def rename_test_git_dir
  dot_git = File.join(File.dirname(__FILE__), 'tests', 'example')
  cp_r File.join(dot_git, '_git'), File.join(dot_git, 'test_repo', '.git'), :remove_destination => true
end
