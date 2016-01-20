require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].execute
  end

  %w[updating reverting updated reverted failed].each do |stage|
    it "posts to slack on slack:deploy:#{stage}" do
      set "slack_run_#{stage}".to_sym, ->{ true }
      expect_any_instance_of(Slackistrano::Capistrano).to receive(:post_to_slack).and_return(double(code: '200'))
      Rake::Task["slack:deploy:#{stage}"].execute
    end

    it "does not post to slack on slack:deploy:#{stage} when disabled" do
      set "slack_run_#{stage}".to_sym, ->{ false }
      expect_any_instance_of(Slackistrano::Capistrano).not_to receive(:post_to_slack)
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end

  [ # stage, color, channel
    ['updating', nil, nil],
    ['reverting', nil, nil],
    ['updated', 'good', nil],
    ['reverted', '#4CBDEC', nil],
    ['failed', 'danger', nil],
    ['updating', nil, 'starting_channel'],
    ['updated', 'good', 'finished_channel'],
    ['reverted', '#4CBDEC', 'rollback_channel'],
    ['failed', 'danger', 'failed_channel'],
  ].each do |stage, color, channel_for_stage|

    it "calls post_as_slack with the right arguments for stage=#{stage}, color=#{color}, channel_for_stage=#{channel_for_stage}" do
      set :"slack_run_#{stage}", -> { true }
      set :slack_team,           -> { 'team' }
      set :slack_token,          -> { 'token' }
      set :slack_webhook,        -> { 'webhook' }
      set :slack_channel,        -> { 'channel' }
      set :slack_icon_url,       -> { 'http://icon.url' }
      set :slack_icon_emoji,     -> { ':emoji:' }
      set :"slack_msg_#{stage}", -> { 'text message' }

      set :"slack_channel_#{stage}", -> { channel_for_stage }
      expected_channel = channel_for_stage || 'channel'

      attachment = {
        text: 'text message',
        color: color,
        fields: [],
        fallback: nil,
        mrkdwn_in: [:text, :pretext]
      }.reject{|k,v| v.nil?}

      expect_any_instance_of(Slackistrano::Capistrano).to receive(:post_to_slack).with(
        team: 'team',
        token: 'token',
        webhook: 'webhook',
        via_slackbot: false,
        payload: {
          channel: expected_channel,
          username: 'Slackistrano',
          icon_url: 'http://icon.url',
          icon_emoji: ':emoji:',
          attachments: [attachment]
        }
      ).and_return(double(code: '200'))
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end

end
