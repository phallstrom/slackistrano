namespace :slack do
  namespace :deploy do

    task :starting do
      run_locally do
        Slackistrano.post(
          team: fetch(:slack_team),
          token: fetch(:slack_token),
          via_slackbot: fetch(:slack_via_slackbot),
          payload: {
            channel: fetch(:slack_channel),
            username: fetch(:slack_username),
            icon_url: fetch(:slack_icon_url),
            icon_emoji: fetch(:slack_icon_emoji),
            text: fetch(:slack_msg_starting)
          }
        )
      end
    end

    task :finished do
      run_locally do
        Slackistrano.post(
          team: fetch(:slack_team),
          token: fetch(:slack_token),
          via_slackbot: fetch(:slack_via_slackbot),
          payload: {
            channel: fetch(:slack_channel),
            username: fetch(:slack_username),
            icon_url: fetch(:slack_icon_url),
            icon_emoji: fetch(:slack_icon_emoji),
            text: fetch(:slack_msg_finished)
          }
        )
      end
    end

    task :failed do
      run_locally do
        Slackistrano.post(
          team: fetch(:slack_team),
          token: fetch(:slack_token),
          via_slackbot: fetch(:slack_via_slackbot),
          payload: {
            channel: fetch(:slack_channel),
            username: fetch(:slack_username),
            icon_url: fetch(:slack_icon_url),
            icon_emoji: fetch(:slack_icon_emoji),
            text: fetch(:slack_msg_failed),
          }
        )
      end
    end

  end
end

namespace :load do
  task :defaults do
    set :slack_team,         ->{ nil } # If URL is 'team.slack.com', value is 'team'. Required.
    set :slack_token,        ->{ nil } # Token from Incoming WebHooks. Required.
    set :slack_channel,      ->{ nil } # Channel to post to. Optional. Defaults to WebHook setting.
    set :slack_icon_url,     ->{ 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
    set :slack_icon_emoji,   ->{ nil } # Emoji to use. Overrides icon_url. Must be a string (ex: ':shipit:')
    set :slack_username,     ->{ 'Slackistrano' }
    set :slack_msg_starting, ->{ "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}." }
    set :slack_msg_finished, ->{ "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}." }
    set :slack_msg_failed,   ->{ "*ERROR!* #{ENV['USER'] || ENV['USERNAME']} failed to deploy branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}." }
    set :slack_via_slackbot, ->{ false } # Set to true to send the message via slackbot instead of webhook
  end
end
