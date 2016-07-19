require 'spec_helper'

describe Slackistrano::Messaging::Default do

  describe '#elapsed_time' do
    it "returns a time like string" do
      expect(subject.send(:elapsed_time)).to match /\A((\d+-)?\d+:)?\d\d:\d\d\Z/
    end
  end

end
