module Slackistrano
  module Messaging
    class Deprecated < Base

      def initialize(env: nil, team: nil, channel: nil, token: nil, webhook: nil)
        run_locally do
          warn("[slackistrano] You are using an outdated configuration that will be removed soon.")
          warn("[slackistrano] Please upgrade soon! <https://github.com/phallstrom/slackistrano>")
        end

        super
      end

      def icon_url
        fetch("slack_icon_url".to_sym) || super
      end

      def icon_emoji
        fetch("slack_icon_emoji".to_sym) || super
      end

      def username
        fetch("slack_username".to_sym) || super
      end

      def deployer
        fetch("slack_deploy_user".to_sym) || super
      end

      def channels_for(action)
        fetch("slack_channel_#{action}".to_sym) || super
      end

      def message_for_updating
        make_message(__method__, super)
      end

      def message_for_reverting
        make_message(__method__, super)
      end

      def message_for_updated
        make_message(__method__, super.merge(color: 'good'))
      end

      def message_for_reverted
        make_message(__method__, super.merge(color: 'warning'))
      end

      def message_for_failed
        make_message(__method__, super.merge(color: 'danger'))
      end

      private ##################################################

      def make_message(method, options={})
        action = method.to_s.sub('message_for_', '')

        return nil unless fetch("slack_run".to_sym, true) && fetch("slack_run_#{action}".to_sym, true)

        attachment = options.merge({
          title:      fetch(:"slack_title_#{action}"),
          pretext:    fetch(:"slack_pretext_#{action}"),
          text:       fetch(:"slack_msg_#{action}", options[:text]),
          fields:     fetch(:"slack_fields_#{action}", []),
          fallback:   fetch(:"slack_fallback_#{action}"),
          mrkdwn_in:  [:text, :pretext]
        }).reject{|k, v| v.nil? }

        {attachments: [attachment]}
      end

    end
  end
end
