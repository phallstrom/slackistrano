require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].execute
  end

  %w(updating reverting updated reverted failed).each do |stage|
    it "does not post to slack on slack:deploy:#{stage} with dry-run" do
      set "slack_channel".to_sym, ->{ %w[one two] }
      set "slack_run_#{stage}".to_sym, -> { true }
      allow(::Capistrano::Configuration).to receive(:dry_run?).and_return true
      expect(Slackistrano::Capistrano).not_to receive(:post_to_slack)
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end

  %w(updating reverting updated reverted failed).each do |stage|
    it "post to slack on slack:deploy:#{stage} without dry-run" do
      set "slack_channel".to_sym, ->{ %w[one two] }
      set "slack_run_#{stage}".to_sym, -> { true }
      allow(::Capistrano::Configuration).to receive(:dry_run?).and_return(false)
      expect_any_instance_of(Slackistrano::Capistrano).to receive(:post_to_slack).twice.and_return(double(code: '200'))
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end
end
