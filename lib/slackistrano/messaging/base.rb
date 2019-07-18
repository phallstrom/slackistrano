require 'forwardable'
require_relative 'helpers'

module Slackistrano
  module Messaging
    class Base

      include Helpers

      extend Forwardable
      def_delegators :env, :fetch

      attr_reader :team, :token, :webhook, :options

      def initialize(options = {})
        @options = options.dup

        @env = options.delete(:env)
        @team = options.delete(:team)
        @channel = options.delete(:channel)
        @token = options.delete(:token)
        @webhook = options.delete(:webhook)
      end

      def payload_for_starting
        {
          text: "#{deployer} has started deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_updating
        {
          text: "#{deployer} is deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_reverting
        {
          text: "#{deployer} has started rolling back branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_updated
        {
          text: "#{deployer} has finished deploying branch #{branch} of #{application} to #{stage}"
        }
      end

      def payload_for_reverted
        {
          text: "#{deployer} has finished rolling back branch of #{application} to #{stage}"
        }
      end

      def payload_for_failed
        {
          text: "#{deployer} has failed to #{deploying? ? 'deploy' : 'rollback'} branch #{branch} of #{application} to #{stage}"
        }
      end

      def channels_for(action)
        @channel
      end

      ################################################################################

      def payload_for(action)
        method = "payload_for_#{action}"
        respond_to?(method) && send(method)
      end

      def via_slackbot?
        @webhook.nil?
      end

    end
  end
end

require_relative 'default'
require_relative 'null'
