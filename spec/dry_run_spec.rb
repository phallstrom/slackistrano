require 'spec_helper'

describe Slackistrano do
  %w[updating reverting updated reverted failed].each do |stage|
    it "does not post to slack on slack:deploy:#{stage}" do
      set "slack_run_#{stage}".to_sym, ->{ true }
      expect(Slackistrano).not_to receive(:post)
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end

end
