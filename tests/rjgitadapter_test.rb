require 'rubygems'
require 'test/unit'
require 'mocha/setup'
require 'grack/git_adapter'
require 'stringio'

require './lib/rjgit_grack'


class RJGitAdapterTest < Test::Unit::TestCase
  include Grack
  
  def example
    File.expand_path(File.join(File.dirname(__FILE__),'example'))
  end
  
  def test_repo
    File.join(example, 'test_repo')
  end

  def setup
    @test_git = RJGitAdapter.new
    @test_git.repository_path = test_repo
  end
  
  def repo_test
    assert_equal true, @test_git.send(:repo).is_a?(RJGit::Repo)
  end

  def test_advertise_refs
    output = StringIO.new
    RJGit::RJGitUploadPack.any_instance.expects(:advertise_refs).returns("refs advertised")
    @test_git.handle_pack('git-upload-pack', nil, output, {:advertise_refs => true})    
    assert_equal "refs advertised", output.string
  end

  def test_receive_pack
    msg = "test"
    result = "result"
    input = StringIO.new(msg)
    output = StringIO.new
    RJGit::RJGitReceivePack.any_instance.expects(:process).with(msg).returns(StringIO.new(result))
    @test_git.handle_pack('git-receive-pack', input, output)
    assert_equal result, output.string
  end

  def test_upload_pack
    msg = "test"
    result = "result"
    input = StringIO.new(msg)
    output = StringIO.new
    RJGit::RJGitUploadPack.any_instance.expects(:process).with(msg).returns(StringIO.new(result))
    @test_git.handle_pack('git-upload-pack', input, output)
    assert_equal result, output.string
  end

  def test_update_server
    RJGit::Repo.any_instance.stubs(:update_server_info).returns(true)
    assert_equal true, @test_git.update_server_info
  end
  
  def test_get_config_setting
    assert_equal 'false', @test_git.config('core.bare')
    assert_equal nil, @test_git.config('core.bare.nothing')
    assert_equal Hash, @test_git.config('core').class
    RJGit::Repo.any_instance.stubs(:config).raises(RuntimeError)
    assert_equal nil, @test_git.config('core.bare')
  end
  
end