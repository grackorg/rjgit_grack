require 'rubygems'
require 'minitest/autorun'
require 'minitest/unit'
require 'rack/test'
require 'mocha/setup'
require 'stringio'
require 'grack/app'

require './lib/rjgit_grack'

class RJGitAdapterTest < Minitest::Test
  include Grack
  
  def example
    File.expand_path(File.join(File.dirname(__FILE__),'example'))
  end
  
  def stock_repo
    File.join(example, 'test_repo')
  end

  def test_repo
    @test_repo
  end

  def setup
    init_example_repository
  end

  def teardown
    remove_example_repository
  end

  def init_example_repository
    @repositories_root = Pathname.new(Dir.mktmpdir('grack-testing'))
    @test_repo = @repositories_root + 'example_repo.git'

    FileUtils.cp_r(stock_repo, @test_repo)
  end

  def remove_example_repository
    FileUtils.remove_entry_secure(@repositories_root)
  end
end


class HookTest < RJGitAdapterTest
  include Rack::Test::Methods

  def hooks
    {
      :postUpload => Proc.new do |pack, wants, haves|
        @postupload = true
      end,
      :preUpload => Proc.new do |pack, wants, haves|
        @preupload = true
      end,
      :preReceive => Proc.new do |pack, commands|
        @prereceive = true
      end,
      :postReceive => Proc.new do |pack, commands|
        @postreceive = true
      end
    }
  end

  def app
    Grack::App.new(app_config)
  end

  def app_config
    {
      :root => @repositories_root,
      :allow_pull => true,
      :allow_push => true,
      :git_adapter_factory => ->{ RJGitAdapter.new(hooks) }
    }
  end

  def example_repo_urn
    '/example_repo.git'
  end

  def setup
    super
    @prereceive = false
    @postreceive = false
    @preupload = false
    @postupload = false
  end

  def test_receive_hook
    assert_equal false, @prereceive
    assert_equal false, @postreceive

    data = "00a5cb067e06bdf6e34d4abebf6cf2de85d65a52c65e 9a95842eb477aec2ee7938e354a254c35857e94e refs/heads/master\x00 report-status side-band-64k agent=git/1.9.5.(Apple.Git-50.3)0000PACK\x00\x00\x00\x02\x00\x00\x00\x03\x91\x0Ex\x9C\x9D\xCBA\n\xC3 \x10@\xD1\xBD\xA7p_\b:\xEA\x98B\t]t\xDFM/0\xEAH\x02I\f\xE9\x84^\xBF\xA1G\xE8\xF2\xC1\xFF\xB23k\xA0DW \xAA\xC0\x06k\x8E\xD6x\x9F\xAC\xA5\xC0\xBDs\xD9E\x88\x19-\x93U\e\xED\xBC\x8A\xCE\xC9`<\xD3T*\xB2\xF3\xC5S\xE2T1W(\xDC\x87\x82\x81\x02d\f\xAC\xE8\x90\xB1\xED\xFAA\x1F\xD2\xCF\x85E\x9A\xBE\x95\x13]\xFB\xE1\xBE\x8D\xD3\xDC\x1DG\xB7\xCE\x83\xB6>\x18\xF4\x0E<\xEA\x8B\xB1\xC6\xA8\xDC\x96e\x12\xE1\x7F\x7F\xF5\xE2\xB7\xA8/\x8CJD\xB1\xA0\x02x\x9C340031Q(I-.a\xD8\xB4\xF3\xCC\xF4\xDD\xFC.\xA2\xE7\xF2O\x8B]_\xC2s6\xE1\xB7\x97\x03\x00\xC0\x92\rX;x\x9C\xCBH\xCD\xC9\xC9\xE7*I-.\xE1\x02\x00\x19\t\x03\xE9\x91&)\xD1#\xD6\xB0\x81,\x152\xA4\xFA\xF2p\xF3\xC6\xA5\x9CT"
    post(
      "#{example_repo_urn}/git-receive-pack",
      data,
      {'CONTENT_TYPE' => 'application/x-git-receive-pack-request'}
    )

    assert_equal true, @prereceive
    assert_equal true, @postreceive
  end

  def test_upload_hook
    assert_equal false, @preupload
    assert_equal false, @postupload
    data = "0090want cb067e06bdf6e34d4abebf6cf2de85d65a52c65e multi_ack_detailed no-done side-band-64k thin-pack ofs-delta agent=git/1.9.5.(Apple.Git-50.3)\n0032want cb067e06bdf6e34d4abebf6cf2de85d65a52c65e\n00000009done\n"

    post(
      "#{example_repo_urn}/git-upload-pack",
      data,
      {'CONTENT_TYPE' => 'application/x-git-upload-pack-request'}
    )

    assert_equal true, @preupload
    assert_equal true, @postupload
  end

end

class RJGitAdapterAPITest < RJGitAdapterTest

  def setup
    super
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
    assert_equal "001e# service=git-upload-pack\n0000refs advertised", output.string
  end

  def test_receive_pack
    msg = "test"
    result = "result"
    input = StringIO.new(msg)
    output = StringIO.new
    RJGit::RJGitReceivePack.any_instance.expects(:process).with(msg).returns([StringIO.new(result), nil])
    @test_git.handle_pack('git-receive-pack', input, output)
    assert_equal result, output.string
  end

  def test_upload_pack
    msg = "test"
    result = "result"
    input = StringIO.new(msg)
    output = StringIO.new
    RJGit::RJGitUploadPack.any_instance.expects(:process).with(msg).returns([StringIO.new(result), nil])
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