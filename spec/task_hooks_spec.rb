require 'spec_helper'

describe Slackistrano do

  describe "before/after hooks" do

    it "invokes slack:deploy:starting before deploy:starting" do
      expect(Rake::Task['deploy:starting'].prerequisites).to include 'slack:deploy:starting'
    end

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

    it "invokes all slack:deploy tasks before slack:deploy:test" do
      expect(Rake::Task['slack:deploy:test'].prerequisites).to match %w[starting updating updated reverting reverted failed]
    end
  end

end
