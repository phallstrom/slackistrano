require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].execute
  end

  context "when :slack_channel is an array" do
    %w[updating reverting updated reverted failed].each do |stage|
      it "posts to slack on slack:deploy:#{stage} in every channel" do
        set "slack_channel".to_sym, ->{ %w[one two] }
        set "slack_run_#{stage}".to_sym, ->{ true }
        expect_any_instance_of(Slackistrano::Capistrano).to receive(:post_to_slack).twice.and_return(double(code: '200'))
        Rake::Task["slack:deploy:#{stage}"].execute
      end
    end
  end

end
