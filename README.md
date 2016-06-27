# Slackistrano

[![Gem Version](https://badge.fury.io/rb/slackistrano.png)](http://badge.fury.io/rb/slackistrano)
[![Code Climate](https://codeclimate.com/github/phallstrom/slackistrano.png)](https://codeclimate.com/github/phallstrom/slackistrano)
[![Build Status](https://travis-ci.org/phallstrom/slackistrano.png?branch=master)](https://travis-ci.org/phallstrom/slackistrano)

Send notifications to [Slack](https://slack.com) about [Capistrano](http://www.capistranorb.com) deployments.

If you need Capistrano v2 support, check out [capistrano-slack](https://github.com/j-mcnally/capistrano-slack).

## NOTE: Upgrading from 1.x? Not Getting Notifications?

Version 2.0 has changed how Slackistrano must be loaded in your Gemfile and Capfile. See the *Installation* section
below current install.

## Requirements

- Capistrano >= 3.1.0
- Ruby >= 2.0
- A Slack account

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slackistrano'
```

And then execute:

```bash
$ bundle
```

## Configuration

You have two options to notify a channel in Slack when you deploy:

 1. Using *Incoming WebHooks* integration, offering more options but requires one of the five free integrations. This is the default option.
 2. Using *Slackbot*, which will not use one of the five free integrations. Enable via the `:slack_via_slackbot` option.

In both case, you need to enable the integration inside Slack and get the token and/or webhook url that will be needed later.

Require the library in your application's Capfile:

```ruby
require 'slackistrano/capistrano'
```

If you post using *Incoming Webhooks* you need to set your webhook url in your application's config/deploy.rb:

```ruby
set :slack_webhook, "https://hooks.slack.com/services/XXX/XXX/XXX"
```

If you choose to post using *Slackbot* you **must** set your team, token, and channel in your application's config/deploy.rb:

```ruby
set :slack_via_slackbot, true
set :slack_team, "teamname"
set :slack_token, "xxxxxxxxxxxxxxxxxxxxxxxx"
set :slack_channel, '#general'
```

You can set `:slack_channel` (or any of the `:slack_channel_xxxx` settings) to an array and Slackistrano
will post to each channel. For example:

```ruby
set :slack_channel, ['#general', '#ops']
```

Optionally, override the other slack settings.

```ruby
set :slack_channel_updating,   -> { nil } # Channel to post to. Defaults to :slack_channel.
set :slack_channel_reverting,  -> { nil } # Channel to post to. Defaults to :slack_channel.
set :slack_channel_updated,    -> { nil } # Channel to post to. Defaults to :slack_channel.
set :slack_channel_reverted,   -> { nil } # Channel to post to. Defaults to :slack_channel.
set :slack_channel_failed,     -> { nil } # Channel to post to. Defaults to :slack_channel.

set :slack_icon_url,           -> { 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
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
set :slack_msg_failed,         -> { "#{fetch :slack_deploy_user} has failed to #{fetch :slack_deploy_or_rollback} branch #{fetch :branch} of #{fetch :application} to #{fetch :stage, 'an unknown stage'}" }

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
```

**Note**: You may wish to disable one of the notifications if another service (ex:
Honeybadger) also displays a deploy notification.

Test your setup by running:

```bash
$ cap production slack:deploy:updating
$ cap production slack:deploy:reverting
$ cap production slack:deploy:updated
$ cap production slack:deploy:reverted
$ cap production slack:deploy:failed
```

## Formatted messages

Slack allows you to send complex content, composed by fields. You can use the `fields` and `fallback` variables in order to have a well formatted message as follows:

```ruby
set :slack_revision, -> { `git rev-parse origin/#{fetch(:branch)}`.strip! }
set :slack_msg_updated, nil
set :slack_fallback_updated, "#{fetch(:slack_deploy_user)} deployed #{fetch(:application)} on #{fetch(:stage)}"
set :slack_fields_updated,
  [
    {
      title: "Project",
      value: "<https://github.com/XXXXX/#{fetch(:application)}|#{fetch(:application)}>",
      short: true
    },
    {
      title: "Environment",
      value: fetch(:stage),
      short: true
    },
    {
      title: "Deployer",
      value: fetch(:slack_deploy_user),
      short: true
    },
    {
      title: "Revision",
      value: "<https://github.com/XXXXX/#{fetch(:application)}/commit/#{fetch(:slack_revision)}|#{fetch(:slack_revision)[0..6]}>",
      short: true
    }
  ]
```

It will produce the following format:
![Formatted message](https://raw.githubusercontent.com/phallstrom/slackistrano/master/examples/fomatting_with_fields.png)

**Note 1:** *The `fallback` field is required in order to display notifications when using `fields`.*

**Note 2:** *The `fields` configuration requires you to use webhooks.*

**Note 3:** *Stages may contain different values for a symbol, e.g. `config/deploy/stage1.rb` may contain `set :branch, 'my-branch'`, and `config/deploy/stage2.rb` contains `set :branch, 'another-branch'`. The example above shows how the `:branch` value is properly loaded from each stage within the `config/deploy.rb` file.*

More information: [https://api.slack.com/docs/attachments](https://api.slack.com/docs/attachments) and [http://capistranorb.com/documentation/faq/how-can-i-access-stage-configuration-variables/](http://capistranorb.com/documentation/faq/how-can-i-access-stage-configuration-variables/)

To add time elapsed to the `slack_fields_updated` an option can be set
(not enabled per default):

```
set :slack_time_elapsed_enabled, true
```

## Usage

Deploy your application like normal and you should see messages in the channel
you specified.

## TODO

- Notify about incorrect configuration settings.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
