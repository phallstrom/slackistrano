namespace :slack do
  namespace :deploy do
    def make_attachments(stage, options={})
      attachments = options.merge({
        title: fetch(:"slack_title_#{stage}"),
        pretext: fetch(:"slack_pretext_#{stage}"),
        text: fetch(:"slack_msg_#{stage}"),
        fields: fetch(:"slack_fields_#{stage}"),
        fallback: fetch(:"slack_fallback_#{stage}"),
        mrkdwn_in: [:text, :pretext]
      }).reject{|k, v| v.nil? }
      [attachments]
    end
    
    post_slackistrano = ->(channel, attachments) do
      Slackistrano.post(
        team: fetch(:slack_team),
        token: fetch(:slack_token),
        webhook: fetch(:slack_webhook),
        via_slackbot: fetch(:slack_via_slackbot),
        payload: {
          channel: channel,
          username: fetch(:slack_username),
          icon_url: fetch(:slack_icon_url),
          icon_emoji: fetch(:slack_icon_emoji),
          attachments: attachments
        }
      )
    end

    task :updating do
      set(:slack_deploy_or_rollback, 'deploy')
      if fetch(:slack_run_updating)
        run_locally do
          post_slackistrano.(fetch(:slack_channel_updating) || fetch(:slack_channel),
                             make_attachments(:updating))
        end
      end
    end

    task :reverting do
      set(:slack_deploy_or_rollback, 'rollback')
      if fetch(:slack_run_reverting)
        run_locally do
          post_slackistrano.(fetch(:slack_channel_reverting) || fetch(:slack_channel),
                             make_attachments(:reverting))
        end
      end
    end


    task :updated do
      if fetch(:slack_run_updated)
        run_locally do
          post_slackistrano.(fetch(:slack_channel_updated) || fetch(:slack_channel),
                             make_attachments(:updated, color: 'good'))
        end
      end
    end

    task :reverted do
      if fetch(:slack_run_reverted)
        run_locally do
          post_slackistrano.(fetch(:slack_channel_reverted) || fetch(:slack_channel),
                             make_attachments(:reverted, color: '#4CBDEC'))
        end
      end
    end

    task :failed do
      if fetch(:slack_run_failed)
        run_locally do
          post_slackistrano.(fetch(:slack_channel_failed) || fetch(:slack_channel),
                             make_attachments(:failed, color: 'danger'))
        end
      end
    end

  end
end

before 'deploy:updating',           'slack:deploy:updating'
before 'deploy:reverting',          'slack:deploy:reverting'
after  'deploy:finishing',          'slack:deploy:updated'
after  'deploy:finishing_rollback', 'slack:deploy:reverted'
after  'deploy:failed',             'slack:deploy:failed'

namespace :load do
  task :defaults do

    set :slack_team,               -> { nil } # If URL is 'team.slack.com', value is 'team'.
    set :slack_token,              -> { nil } # Token from Incoming WebHooks.
    set :slack_webhook,            -> { nil } # Incoming WebHook URL.
    set :slack_via_slackbot,       -> { false } # Set to true to send the message via slackbot instead of webhook
    set :slack_channel,            -> { nil } # Channel to post to. Optional. Defaults to WebHook setting.

    # Optional, overridable settings

    set :slack_channel_updating,   -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_reverting,  -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_updated,    -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_reverted,   -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_failed,     -> { nil } # Channel to post to. Defaults to :slack_channel.

    set :slack_icon_url,           -> { 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
    set :slack_icon_emoji,         -> { nil } # Emoji to use. Overrides icon_url. Must be a string (ex: ':shipit:')
    set :slack_username,           -> { 'Slackistrano' }

    set :slack_run_updating,       -> { true } # Set to false to disable deploy starting message.
    set :slack_run_reverting,      -> { true } # Set to false to disable rollback starting message.
    set :slack_run_updated,        -> { true } # Set to false to disable deploy finished message.
    set :slack_run_reverted,       -> { true } # Set to false to disable rollback finished message.
    set :slack_run_failed,         -> { true } # Set to false to disable failure message.

    set :slack_deploy_user,        -> { ENV['USER'] || ENV['USERNAME'] }

    set :slack_msg_updating,       -> { "#{fetch :slack_deploy_user} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }
    set :slack_msg_reverting,      -> { "#{fetch :slack_deploy_user} has started rolling back branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }
    set :slack_msg_updated,        -> { "#{fetch :slack_deploy_user} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }
    set :slack_msg_reverted,       -> { "#{fetch :slack_deploy_user} has finished rolling back branch of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }

    # :slack_or_deploy is set in several tasks above.
    set :slack_msg_failed,         -> { "#{fetch :slack_deploy_user} has failed to #{fetch(:slack_deploy_or_rollback) || 'deploy'} branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }

    set :slack_fields_updating,    -> { [] }
    set :slack_fields_reverting,   -> { [] }
    set :slack_fields_updated,     -> { [] }
    set :slack_fields_reverted,    -> { [] }
    set :slack_fields_failed,      -> { [] }

    set :slack_fallback_updating,  -> { nil }
    set :slack_fallback_reverting, -> { nil }
    set :slack_fallback_updated,   -> { nil }
    set :slack_fallback_reverted,  -> { nil }
    set :slack_fallback_failed,    -> { nil }

    set :slack_title_updating,     -> { nil }
    set :slack_title_reverting,    -> { nil }
    set :slack_title_updated,      -> { nil }
    set :slack_title_reverted,     -> { nil }
    set :slack_title_failed,       -> { nil }

    set :slack_pretext_updating,   -> { nil }
    set :slack_pretext_reverting,  -> { nil }
    set :slack_pretext_updated,    -> { nil }
    set :slack_pretext_reverted,   -> { nil }
    set :slack_pretext_failed,     -> { nil }

  end
end
