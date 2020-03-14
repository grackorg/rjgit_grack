require 'rjgit'

module Grack

  class RJGitAdapter < GitAdapter

    def initialize(hooks = nil)
      @repository_path = nil
      @hooks = hooks
    end
  
    def handle_pack(pack_type, io_in, io_out, opts = {})
      pack = case pack_type
        when 'git-upload-pack'
          RJGit::RJGitUploadPack.new(repo)
        when 'git-receive-pack'
          RJGit::RJGitReceivePack.new(repo)
      end
      return nil if pack.nil?
      set_hooks(pack) if @hooks
      if opts[:advertise_refs] then
        io_out.write advertisement_prefix(pack_type)
        result = pack.advertise_refs
      else
        result = pack.process(io_in.read).first.read
      end
      io_out.write(result)
    end

    def update_server_info
      repo.update_server_info
    end

    def config(key)
      begin
        settings = repo.config
      rescue
        return nil
      end
      key.split(".").each do |domain|
        begin
          settings = settings[domain]
        rescue
          return nil
        end
      end
      settings.is_a?(Hash) ? settings : settings.to_s
    end

    private

    def repo
      RJGit::Repo.new(repository_path)
    end

    def set_hooks(pack)
      if pack.is_a?(RJGit::RJGitUploadPack)
        pack.jpack.setPostUploadHook(Grack::Hooks::PostUploadHook.new(@hooks[:postUpload])) if @hooks[:postUpload]
        pack.jpack.setPreUploadHook(Grack::Hooks::PreUploadHook.new(@hooks[:preUpload])) if @hooks[:preUpload]
      elsif pack.is_a?(RJGit::RJGitReceivePack)
        pack.jpack.setPostReceiveHook(Grack::Hooks::PostReceiveHook.new(@hooks[:postReceive])) if @hooks[:postReceive]
        pack.jpack.setPreReceiveHook(Grack::Hooks::PreReceiveHook.new(@hooks[:preReceive])) if @hooks[:preReceive]
      end
    end
  
  end

end
