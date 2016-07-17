namespace :slack do
  namespace :deploy do

    task :updating do
      Slackistrano::Capistrano.new(self).run(:updating)
    end

    task :reverting do
      Slackistrano::Capistrano.new(self).run(:reverting)
    end

    task :updated do
      Slackistrano::Capistrano.new(self).run(:updated)
    end

    task :reverted do
      Slackistrano::Capistrano.new(self).run(:reverted)
    end

    task :failed do
      Slackistrano::Capistrano.new(self).run(:failed)
    end

    task :test => %i[updating updated reverting reverted failed] do
      # all tasks run as dependencies
    end

  end
end

before 'deploy:updating',           'slack:deploy:updating'
before 'deploy:reverting',          'slack:deploy:reverting'
after  'deploy:finishing',          'slack:deploy:updated'
after  'deploy:finishing_rollback', 'slack:deploy:reverted'
after  'deploy:failed',             'slack:deploy:failed'
