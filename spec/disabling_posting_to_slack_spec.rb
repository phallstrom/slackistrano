require 'spec_helper'

describe Slackistrano do
  context "when :slackistrano is :disabled" do
    before(:all) do
      set :slackistrano, false
    end
    
    %w[starting updating reverting updated reverted failed].each do |stage|
      it "doesn't post on slack:deploy:#{stage}" do
        expect_any_instance_of(Slackistrano::Capistrano).not_to receive(:post)
        Rake::Task["slack:deploy:#{stage}"].execute
      end
    end
  end
end
