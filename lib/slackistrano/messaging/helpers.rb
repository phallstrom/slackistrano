module Slackistrano
  module Messaging
    module Helpers

      protected

      def branch
        fetch(:branch)
      end

      def application
        fetch(:application)
      end

      def stage(default = 'an unknown stage')
        fetch(:stage, default)
      end

    end
  end
end
