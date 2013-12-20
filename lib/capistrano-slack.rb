require 'capistrano_slack/version'
require 'net/http'
require 'json'

load File.expand_path("../capistrano_slack/tasks/slack.rake", __FILE__)

module CapistranoSlack
  def self.post(team: nil, token: nil, payload: {})
    uri = URI("https://#{team}.slack.com/services/hooks/incoming-webhook")
    res = Net::HTTP.post_form(uri, 'token' => token, 'payload' => payload.to_json)
  rescue => e
    puts "There was an error notifying Slack."
    puts e.inspect
  end
end

