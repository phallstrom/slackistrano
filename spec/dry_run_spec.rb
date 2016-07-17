require 'spec_helper'

describe Slackistrano do
  before(:all) do
    set :slackistrano, { klass: Slackistrano::Messaging::Default }
  end

  %w[updating reverting updated reverted failed].each do |stage|
    it "does not post to slack on slack:deploy:#{stage}" do
      allow_any_instance_of(Slackistrano::Capistrano).to receive(:dry_run?).and_return(true)
      expect_any_instance_of(Slackistrano::Capistrano).to receive(:post_dry_run)
      expect_any_instance_of(Slackistrano::Capistrano).not_to receive(:post)
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end

end
