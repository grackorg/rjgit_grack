module Grack 
  module Hooks

    class Hook
      def initialize(hook)
        @hook = hook
      end
    end

    class PreReceiveHook < Hook
      include org.eclipse.jgit.transport.PreReceiveHook
      def onPreReceive(pack, commands)
        @hook.call(commands.to_a.map {|cmd|
          {
            :ref_name => cmd.getRefName,
            :old_id => cmd.getOldId.getName,
            :new_id => cmd.getNewId.getName,
            :type => cmd.getType.toString,
          }
        })
      end
    end

    class PostReceiveHook < Hook
      include org.eclipse.jgit.transport.PostReceiveHook
      def onPostReceive(pack, commands)
        @hook.call(commands.to_a.map {|cmd|
          {
            :ref_name => cmd.getRefName,
            :old_id => cmd.getOldId.getName,
            :new_id => cmd.getNewId.getName,
            :type => cmd.getType.toString,
            :result => cmd.getResult.toString
          }
        })
      end
    end

    class PostUploadHook < Hook
      include org.eclipse.jgit.transport.PostUploadHook
      def onPostUpload(stats)
        @hook.call(stats)
      end
    end

    class PreUploadHook < Hook
      include org.eclipse.jgit.transport.PreUploadHook

      def onSendPack(pack, wants, haves)
        @hook.call(wants.to_a.map {|obj| obj.getName}, haves.to_a.map {|obj| obj.getName})
      end

      def onBeginNegotiateRound(pack, wants, cnt_offered); end
      def onEndNegotiateRound(pack, wants, cnt_common, cnt_not_found, ready ); end

    end

  end
end