require 'spec_helper'

describe Slackistrano::Messaging::Default do

  describe "#icon_url" do
    it "returns a default" do
      expect(subject.icon_url).to match(/phallstrom.*slackistrano.png/)
    end

    it "returns a custom option" do
      allow(subject).to receive(:options).and_return(icon_url: 'http://example.com/foo.png')
      expect(subject.icon_url).to eq 'http://example.com/foo.png'
    end
  end

  describe "#icon_emoji" do
    it "returns a default of nil" do
      expect(subject.icon_emoji).to eq nil
    end

    it "returns a custom option" do
      allow(subject).to receive(:options).and_return(icon_emoji: ':thumbsup:')
      expect(subject.icon_emoji).to eq ':thumbsup:'
    end
  end

  describe "#username" do
    it "returns a default" do
      expect(subject.username).to eq 'Slackistrano'
    end

    it "returns a custom option" do
      allow(subject).to receive(:options).and_return(username: 'Codan the Deployer')
      expect(subject.username).to eq 'Codan the Deployer'
    end
  end

  describe '#deployer' do
    it "delegates to fetch" do
      expect(subject).to receive(:fetch).with(:local_user, anything)
      subject.deployer
    end

    it "has a default" do
      ENV['USER'] = 'cappy'
      expect(subject.deployer).to eq 'cappy'
    end
  end

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
