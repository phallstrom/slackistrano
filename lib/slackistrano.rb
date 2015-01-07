require 'slackistrano/version'
require 'net/http'
require 'json'

load File.expand_path("../slackistrano/tasks/slack.rake", __FILE__)

module Slackistrano

  #
  #
  #
  def self.post(team: nil, token: nil, webhook: nil, via_slackbot: false, payload: {})
    if via_slackbot
      post_as_slackbot(team: team, token: token, webhook: webhook, payload: payload)
    else
      post_as_webhook(team: team, token: token, webhook: webhook, payload: payload)
    end
  rescue => e
    puts "There was an error notifying Slack."
    puts e.inspect
  end

  #
  #
  #
  def self.post_as_slackbot(team: nil, token: nil, webhook: webhook(), payload: {})
    uri = URI(URI.encode("https://#{team}.slack.com/services/hooks/slackbot?token=#{token}&channel=#{payload[:channel]}"))

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request_post uri.request_uri, payload[:text]
    end
  end

  #
  #
  #
  def self.post_as_webhook(team: nil, token: nil, webhook: webhook(), payload: {})
    params = {'payload' => payload.to_json}

    if webhook.nil?
      webhook = "https://#{team}.slack.com/services/hooks/incoming-webhook"
      params.merge!('token' => token)
    end

    uri = URI(webhook)
    Net::HTTP.post_form(uri, params)
  end


end

