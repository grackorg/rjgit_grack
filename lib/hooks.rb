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
        @hook.call(pack, commands.to_a)
      end
    end

    class PostReceiveHook < Hook
      include org.eclipse.jgit.transport.PostReceiveHook
      def onPostReceive(pack, commands)
        @hook.call(pack, commands.to_a)
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
        @hook.call(pack, wants.to_a, haves.to_a)
      end

      def onBeginNegotiateRound(pack, wants, cnt_offered); end
      def onEndNegotiateRound(pack, wants, cnt_common, cnt_not_found, ready ); end

    end

  end
end