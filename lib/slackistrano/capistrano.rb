require 'net/http'
require 'json'
require 'forwardable'

load File.expand_path("../tasks/slack.rake", __FILE__)

module Slackistrano
  class Capistrano

    extend Forwardable
    def_delegators :env, :fetch, :run_locally

    #
    #
    #
    def initialize(env)
      @env = env
    end

    #
    #
    #
    def run(action)
      should_run = fetch("slack_run".to_sym)
      should_run &&= fetch("slack_run_#{action}".to_sym)
      return unless should_run

      _self = self
      run_locally { _self.post(action, self) }

    end

    #
    #
    #
    def post(action, backend)
      team = fetch(:slack_team)
      token = fetch(:slack_token)
      webhook = fetch(:slack_webhook)
      via_slackbot = fetch(:slack_via_slackbot)

      channels = fetch(:slack_channel)
      channel_action = "slack_channel_#{action}".to_sym
      channels = fetch(channel_action) if fetch(channel_action)
      channels = Array(channels)
      if via_slackbot == false && channels.empty?
        channels = [nil] # default webhook channel
      end

      payload = {
        username: fetch(:slack_username),
        icon_url: fetch(:slack_icon_url),
        icon_emoji: fetch(:slack_icon_emoji),
      }

      payload[:attachments] = case action
                              when :updated
                                make_attachments(action, color: 'good')
                              when :reverted
                                make_attachments(action, color: '#4CBDEC')
                              when :failed
                                make_attachments(action, color: 'danger')
                              else
                                make_attachments(action)
                              end

      channels.each do |channel|
        payload[:channel] = channel

        # This is a nasty hack, but until Capistrano provides an official way to determine if
        # --dry-run was passed this is the only option.
        # See https://github.com/capistrano/capistrano/issues/1462
        if ::Capistrano::Configuration.env.send(:config)[:sshkit_backend] == SSHKit::Backend::Printer
          backend.info("[slackistrano] Slackistrano Dry Run:")
          backend.info("[slackistrano]   Team: #{team}")
          backend.info("[slackistrano]   Webhook: #{webhook}")
          backend.info("[slackistrano]   Via Slackbot: #{via_slackbot}")
          backend.info("[slackistrano]   Payload: #{payload.to_json}")

        # Post to the channel.
        else

          begin
            response = post_to_slack(team: team,
                                     token: token,
                                     webhook: webhook,
                                     via_slackbot: via_slackbot,
                                     payload: payload)

          rescue => e
            backend.warn("[slackistrano] Error notifying Slack!")
            backend.warn("[slackistrano]   Error: #{e.inspect}")
          end

          if response.code !~ /^2/
            warn("[slackistrano] Slack API Failure!")
            warn("[slackistrano]   URI: #{response.uri}")
            warn("[slackistrano]   Code: #{response.code}")
            warn("[slackistrano]   Message: #{response.message}")
            warn("[slackistrano]   Body: #{response.body}") if response.message != response.body && response.body !~ /<html/
          end
        end
      end

    end

    #
    #
    #
    def make_attachments(action, options={})
      attachments = options.merge({
        title:      fetch(:"slack_title_#{action}"),
        pretext:    fetch(:"slack_pretext_#{action}"),
        text:       fetch(:"slack_msg_#{action}"),
        fields:     fetch(:"slack_fields_#{action}"),
        fallback:   fetch(:"slack_fallback_#{action}"),
        mrkdwn_in:  [:text, :pretext]
      }).reject{|k, v| v.nil? }
      [attachments]
    end
    private :make_attachments

    #
    #
    #
    def post_to_slack(via_slackbot: nil, team: nil, token: nil, webhook: nil, payload: {})
      if via_slackbot
        post_as_slackbot(team: team, token: token, webhook: webhook, payload: payload)
      else
        post_as_webhook(team: team, token: token, webhook: webhook, payload: payload)
      end
    end
    private :post_to_slack

    #
    #
    #
    def post_as_slackbot(team: nil, token: nil, webhook: nil, payload: {})
      uri = URI(URI.encode("https://#{team}.slack.com/services/hooks/slackbot?token=#{token}&channel=#{payload[:channel]}"))

      text = payload[:attachments].collect { |a| a[:text] }.join("\n")

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request_post uri, text
      end
    end
    private :post_as_slackbot

    #
    #
    #
    def post_as_webhook(team: nil, token: nil, webhook: nil, payload: {})
      params = {'payload' => payload.to_json}

      if webhook.nil?
        webhook = "https://#{team}.slack.com/services/hooks/incoming-webhook"
        params.merge!('token' => token)
      end

      uri = URI(webhook)
      Net::HTTP.post_form(uri, params)
    end
    private :post_as_webhook

  end
end
