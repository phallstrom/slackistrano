module Slackistrano
  module Messaging
    class Null < Base
      def payload_for_starting
        nil
      end

      def payload_for_updating
        nil
      end

      def payload_for_reverting
        nil
      end

      def payload_for_updated
        nil
      end

      def payload_for_reverted
        nil
      end

      def payload_for_failed
        nil
      end
    end
  end
end
