require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].execute
  end

  %w[updating reverting updated reverted failed].each do |stage|
    it "does not post to slack on slack:deploy:#{stage}" do
      set "slack_run_#{stage}".to_sym, ->{ true }
      expect(Capistrano::Configuration.env.send(:config)).to receive(:[]).with(:sshkit_backend).and_return(SSHKit::Backend::Printer)
      expect(Slackistrano).not_to receive(:post)
      Rake::Task["slack:deploy:#{stage}"].execute
    end
  end

end
