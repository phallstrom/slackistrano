
namespace :slack do
  namespace :deploy do
    task :starting do
      run_locally do
        text = "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}."
        Slackistrano.post(
          team: fetch(:slack_team),
          token: fetch(:slack_token),
          payload: {
            channel: fetch(:slack_channel),
            username: fetch(:slack_username),
            icon_url: fetch(:slack_icon_url),
            text: text
          }
        )
      end
    end

    task :finished do
      run_locally do
        text = "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}."
        Slackistrano.post(
          team: fetch(:slack_team),
          token: fetch(:slack_token),
          payload: {
            channel: fetch(:slack_channel),
            username: fetch(:slack_username),
            icon_url: fetch(:slack_icon_url),
            text: text
          }
        )
      end
    end
  end
end

before 'deploy:starting', 'slack:deploy:starting'
after 'deploy:finished', 'slack:deploy:finished'

namespace :load do
  task :defaults do
    set :slack_team,         ->{ nil } # If URL is 'team.slack.com', value is 'team'. Required.
    set :slack_token,        ->{ nil } # Token from Incoming WebHooks. Required.
    set :slack_icon_url,     ->{ "http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40" }
    set :slack_channel,      ->{ "#general" }
    set :slack_username,     ->{ "Capistrano" }
  end
end
