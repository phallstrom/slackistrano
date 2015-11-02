require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].invoke
  end

  describe "before/after hooks" do

    it "invokes slack:deploy:updating before deploy:updating" do
      expect(Rake::Task['deploy:updating'].prerequisites).to include 'slack:deploy:updating'
    end

    it "invokes slack:deploy:reverting before deploy:reverting" do
      expect(Rake::Task['deploy:reverting'].prerequisites).to include 'slack:deploy:reverting'
    end

    it "invokes slack:deploy:updated after deploy:finishing" do
      expect(Rake::Task['slack:deploy:updated']).to receive(:invoke)
      Rake::Task['deploy:finishing'].execute
    end

    it "invokes slack:deploy:reverted after deploy:finishing_rollback" do
      expect(Rake::Task['slack:deploy:reverted']).to receive(:invoke)
      Rake::Task['deploy:finishing_rollback'].execute
    end

    it "invokes slack:deploy:failed after deploy:failed" do
      expect(Rake::Task['slack:deploy:failed']).to receive(:invoke)
      Rake::Task['deploy:failed'].execute
    end

  end

  %w[updating reverting updated reverted failed].each do |stage|
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
