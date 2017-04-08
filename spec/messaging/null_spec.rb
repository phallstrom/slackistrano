require 'spec_helper'

describe Slackistrano::Messaging::Null do
  subject(:messaging) { Slackistrano::Messaging::Null.new }
  
  %w[updating reverting updated reverted failed].each do |stage|
    it "returns no payload for on #{stage}" do
      expect(messaging.payload_for(stage)).to be_nil
    end
  end
end
