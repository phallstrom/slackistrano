require 'spec_helper'

describe Slackistrano::Messaging::Default do

  describe '#branch' do
    it "delegates to fetch" do
      expect(subject).to receive(:fetch).with(:branch)
      subject.send(:branch)
    end
  end

  describe '#application' do
    it "delegates to fetch" do
      expect(subject).to receive(:fetch).with(:application)
      subject.send(:application)
    end
  end

  describe '#stage' do
    it "delegates to fetch" do
      expect(subject).to receive(:fetch).with(:stage, anything)
      subject.send(:stage)
    end

    it "has a default" do
      expect(subject.send(:stage, 'default')).to eq 'default'
    end
  end

  describe '#elapsed_time' do
    it "returns a time like string" do
      expect(subject.send(:elapsed_time)).to match /\A((\d+-)?\d+:)?\d\d:\d\d\Z/
    end
  end

end
