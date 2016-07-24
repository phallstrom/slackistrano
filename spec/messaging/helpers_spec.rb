require 'spec_helper'

describe Slackistrano::Messaging::Default do

  describe '#branch' do
    it "delegates to fetch" do
      expect(subject).to receive(:fetch).with(:branch)
      subject.branch
    end
  end

  describe '#application' do
    it "delegates to fetch" do
      expect(subject).to receive(:fetch).with(:application)
      subject.application
    end
  end

  describe '#stage' do
    it "delegates to fetch" do
      expect(subject).to receive(:fetch).with(:stage, anything)
      subject.stage
    end

    it "has a default" do
      expect(subject.stage('default')).to eq 'default'
    end
  end

  describe '#elapsed_time' do
    it "returns a time like string" do
      expect(subject.elapsed_time).to match /\A((\d+-)?\d+:)?\d\d:\d\d\Z/
    end
  end

end
