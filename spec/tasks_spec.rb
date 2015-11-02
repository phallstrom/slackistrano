require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].invoke
  end

  it "invokes slack:deploy:starting after deploy:starting" do
    set :slack_run_starting, ->{ true }
    expect(Slackistrano).to receive :post
    Rake::Task['deploy:starting'].execute
  end

  it "invokes slack:deploy:finished after deploy:finishing" do
    set :slack_run_finished, ->{ true }
    expect(Slackistrano).to receive :post
    Rake::Task['deploy:finishing'].execute
  end

  it "invokes slack:deploy:rollback after deploy:finishing_rollback" do
    set :slack_run_rollback, ->{ true }
    expect(Slackistrano).to receive :post
    Rake::Task['deploy:finishing_rollback'].execute
  end

  it "invokes slack:deploy:failed after deploy:failed" do
    set :slack_run_failed, ->{ true }
    expect(Slackistrano).to receive :post
    Rake::Task['deploy:failed'].execute
  end

  %w[starting finished rollback failed].each do |stage|
    it "posts to slack on slack:deploy:#{stage}" do
      set "slack_run_#{stage}".to_sym, ->{ true }
      expect(Slackistrano).to receive :post
      Rake::Task["slack:deploy:#{stage}"].execute
    end

    it "does not post to slack on slack:deploy:#{stage} when disabled" do
      set "slack_run_#{stage}".to_sym, ->{ false }
      expect(Slackistrano).not_to receive :post
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end

  [ # stage, color, channel
    ['starting', nil, nil],
    ['finished', 'good', nil],
    ['rollback', '#4CBDEC', nil],
    ['failed', 'danger', nil],
    ['starting', nil, 'starting_channel'],
    ['finished', 'good', 'finished_channel'],
    ['rollback', '#4CBDEC', 'rollback_channel'],
    ['failed', 'danger', 'failed_channel'],
  ].each do |stage, color, channel_for_stage|

    it "calls Slackistrano.post with the right arguments for stage=#{stage}, color=#{color}, channel_for_stage=#{channel_for_stage}" do
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

      expect(Slackistrano).to receive(:post).with(
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
      )
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end


end
