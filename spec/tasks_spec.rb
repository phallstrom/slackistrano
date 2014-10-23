require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].invoke
  end

  %w[starting finished failed].each do |stage|

    it "posts to slack on slack:deploy:#{stage}" do
      set "slack_run_#{stage}".to_sym, ->{ true }
      expect(Slackistrano).to receive :post
      Rake::Task["slack:deploy:#{stage}"].execute
    end

    it "calls Slackistrano.post with all the right arguments on slack:deploy:#{stage}" do
      set "slack_run_#{stage}".to_sym, ->{ true }
      set :slack_team,         ->{ 'team' }
      set :slack_token,        ->{ 'token' }
      set :slack_channel,      ->{ 'channel' }
      set :slack_icon_url,     ->{ 'http://icon.url' }
      set :slack_icon_emoji,   ->{ ':emoji:' }
      set "slack_msg_#{stage}".to_sym, ->{ 'text message' }
      expect(Slackistrano).to receive(:post).with(
        team: 'team',
        token: 'token',
        via_slackbot: false,
        payload: {
          channel: 'channel',
          username: 'Slackistrano',
          icon_url: 'http://icon.url',
          icon_emoji: ':emoji:',
          text: 'text message'
        }
      )
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end # of stage loop

end
