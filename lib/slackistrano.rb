require 'slackistrano/version'
require 'net/http'
require 'json'

load File.expand_path("../slackistrano/tasks/slack.rake", __FILE__)

module Slackistrano
  def self.post(team: nil, token: nil, payload: {})
    uri = URI("https://#{team}.slack.com/services/hooks/incoming-webhook")
    res = Net::HTTP.post_form(uri, 'token' => token, 'payload' => payload.to_json)
  rescue => e
    puts "There was an error notifying Slack."
    puts e.inspect
  end
end

