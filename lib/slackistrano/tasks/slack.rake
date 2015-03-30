namespace :slack do
  namespace :deploy do

    task :starting do
      if fetch(:slack_run_starting)
        run_locally do
          Slackistrano.post(
            team: fetch(:slack_team),
            token: fetch(:slack_token),
            webhook: fetch(:slack_webhook),
            via_slackbot: fetch(:slack_via_slackbot),
            payload: {
              channel: fetch(:slack_channel_starting) || fetch(:slack_channel),
              username: fetch(:slack_username),
              icon_url: fetch(:slack_icon_url),
              icon_emoji: fetch(:slack_icon_emoji),
              attachments: [{
                  title: fetch(:slack_title_starting),
                  text: fetch(:slack_msg_starting),
                  mrkdwn_in: [:text]
              }]
            }
          )
        end
      end
    end

    task :finished do
      if fetch(:slack_run_finished)
        run_locally do
          Slackistrano.post(
            team: fetch(:slack_team),
            token: fetch(:slack_token),
            webhook: fetch(:slack_webhook),
            via_slackbot: fetch(:slack_via_slackbot),
            payload: {
              channel: fetch(:slack_channel_finished) || fetch(:slack_channel),
              username: fetch(:slack_username),
              icon_url: fetch(:slack_icon_url),
              icon_emoji: fetch(:slack_icon_emoji),
              attachments: [{
                  color: 'good',
                  title: fetch(:slack_title_finished),
                  text: fetch(:slack_msg_finished),
                  mrkdwn_in: [:text]
              }]
            }
          )
        end
      end
    end

    task :failed do
      if fetch(:slack_run_failed)
        run_locally do
          Slackistrano.post(
            team: fetch(:slack_team),
            token: fetch(:slack_token),
            webhook: fetch(:slack_webhook),
            via_slackbot: fetch(:slack_via_slackbot),
            payload: {
              channel: fetch(:slack_channel_failed) || fetch(:slack_channel),
              username: fetch(:slack_username),
              icon_url: fetch(:slack_icon_url),
              icon_emoji: fetch(:slack_icon_emoji),
              attachments: [{
                  color: 'danger',
                  title: fetch(:slack_title_failed),
                  text: fetch(:slack_msg_failed),
                  mrkdwn_in: [:text]
              }]
            }
          )
        end
      end
    end

  end
end

after 'deploy:starting', 'slack:deploy:starting'
after 'deploy:finished', 'slack:deploy:finished'
after 'deploy:failed',   'slack:deploy:failed'

namespace :load do
  task :defaults do

    set :slack_team,         ->{ nil } # If URL is 'team.slack.com', value is 'team'.
    set :slack_token,        ->{ nil } # Token from Incoming WebHooks.
    set :slack_webhook,      ->{ nil } # Incoming WebHook URL.
    set :slack_via_slackbot, ->{ false } # Set to true to send the message via slackbot instead of webhook

    set :slack_channel,          -> { nil } # Channel to post to. Optional. Defaults to WebHook setting.
    set :slack_channel_starting, -> { nil } # Channel to post to. Optional. Defaults to :slack_channel.
    set :slack_channel_finished, -> { nil } # Channel to post to. Optional. Defaults to :slack_channel.
    set :slack_channel_failed,   -> { nil } # Channel to post to. Optional. Defaults to :slack_channel.
    set :slack_icon_url,         -> { 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
    set :slack_icon_emoji,       -> { nil } # Emoji to use. Overrides icon_url. Must be a string (ex: ':shipit:')
    set :slack_username,         -> { 'Slackistrano' }
    set :slack_run_starting,     -> { true } # Set to false to disable starting message.
    set :slack_run_finished,     -> { true } # Set to false to disable finished message.
    set :slack_run_failed,       -> { true } # Set to false to disable failure message.
    set :slack_msg_starting,     -> { "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }
    set :slack_msg_finished,     -> { "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }
    set :slack_msg_failed,       -> { "#{ENV['USER'] || ENV['USERNAME']} failed to deploy branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }
    set :slack_title_starting,   -> { nil }
    set :slack_title_finished,   -> { nil }
    set :slack_title_failed,     -> { nil }
  end
end
