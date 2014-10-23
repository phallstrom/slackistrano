require 'rake'
require 'slackistrano/version'
require 'net/http'
require 'json'

load File.expand_path("../slackistrano/tasks/slack.rake", __FILE__)

module Slackistrano
  def self.post(team: nil, token: nil, via_slackbot: false, payload: {})
    if via_slackbot
      uri = URI(URI.encode("https://#{team}.slack.com/services/hooks/slackbot?token=#{token}&channel=#{payload[:channel]}"))

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        response = http.request_post uri.request_uri, payload[:text]
      end
    else
      uri = URI("https://#{team}.slack.com/services/hooks/incoming-webhook")
      res = Net::HTTP.post_form(uri, 'token' => token, 'payload' => payload.to_json)
    end
  rescue => e
    puts "There was an error notifying Slack."
    puts e.inspect
  end
end

