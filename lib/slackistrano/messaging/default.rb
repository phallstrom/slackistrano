module Slackistrano
  module Messaging
    class Default < Base

      def icon_url
        super
      end

      def icon_emoji
        super
      end

      def username
        super
      end

      def deployer
        super
      end

      def message_for_updating
        super
      end

      def message_for_reverting
        super
      end

      def message_for_updated
        super
      end

      def message_for_reverted
        super
      end

      def message_for_failed
        super
      end

      def channels_for(action)
        super
      end

      def should_run_for?(action)
        super
      end

    end
  end
end
