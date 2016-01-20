require 'spec_helper'

describe Slackistrano do
  before(:each) do
    Rake::Task['load:defaults'].execute
  end

  describe "before/after hooks" do

    it "invokes slack:deploy:updating before deploy:updating" do
      expect(Rake::Task['deploy:updating'].prerequisites).to include 'slack:deploy:updating'
    end

    it "invokes slack:deploy:reverting before deploy:reverting" do
      expect(Rake::Task['deploy:reverting'].prerequisites).to include 'slack:deploy:reverting'
    end

    it "invokes slack:deploy:updated after deploy:finishing" do
      expect(Rake::Task['slack:deploy:updated']).to receive(:invoke)
      Rake::Task['deploy:finishing'].execute
    end

    it "invokes slack:deploy:reverted after deploy:finishing_rollback" do
      expect(Rake::Task['slack:deploy:reverted']).to receive(:invoke)
      Rake::Task['deploy:finishing_rollback'].execute
    end

    it "invokes slack:deploy:failed after deploy:failed" do
      expect(Rake::Task['slack:deploy:failed']).to receive(:invoke)
      Rake::Task['deploy:failed'].execute
    end

  end

end
