require 'spec_helper'

class NilPayloadMessaging < Slackistrano::Messaging::Default
  def payload_for_starting
    nil
  end

  def channels_for(action)
    "testing"
  end
end

describe Slackistrano do
  before(:all) do
    set :slackistrano, { klass: NilPayloadMessaging }
  end

  it "does not post on starting" do
    expect_any_instance_of(Slackistrano::Capistrano).not_to receive(:post)
    Rake::Task["slack:deploy:starting"].execute
  end

  it "posts on updated" do
    expect_any_instance_of(Slackistrano::Capistrano).to receive(:post).and_return(true)
    Rake::Task["slack:deploy:updated"].execute
  end
end
