namespace :slack do
  namespace :deploy do

    task :updating do
      set(:slack_deploy_or_rollback, 'deploy')
      Slackistrano::Capistrano.new(self).run(:updating)
    end

    task :reverting do
      set(:slack_deploy_or_rollback, 'rollback')
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

  end
end

before 'deploy:updating',           'slack:deploy:updating'
before 'deploy:reverting',          'slack:deploy:reverting'
after  'deploy:finishing',          'slack:deploy:updated'
after  'deploy:finishing_rollback', 'slack:deploy:reverted'
after  'deploy:failed',             'slack:deploy:failed'

namespace :load do
  task :defaults do

    set :slack_team,               -> { nil }   # If URL is 'team.slack.com', value is 'team'.
    set :slack_token,              -> { nil }   # Token from Incoming WebHooks.
    set :slack_webhook,            -> { nil }   # Incoming WebHook URL.
    set :slack_via_slackbot,       -> { false } # Set to true to send the message via slackbot instead of webhook
    set :slack_channel,            -> { nil }   # Channel to post to. Optional. Defaults to WebHook setting.

    # Optional, overridable settings

    set :slack_channel_updating,   -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_reverting,  -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_updated,    -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_reverted,   -> { nil } # Channel to post to. Defaults to :slack_channel.
    set :slack_channel_failed,     -> { nil } # Channel to post to. Defaults to :slack_channel.

    set :slack_icon_url,           -> { 'https://raw.githubusercontent.com/phallstrom/slackistrano/master/slackistrano.png' }
    set :slack_icon_emoji,         -> { nil } # Emoji to use. Overrides icon_url. Must be a string (ex: ':shipit:')
    set :slack_username,           -> { 'Slackistrano' }

    set :slack_run,                -> { true } # Set to false to disable all messages.
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
