# Slackistrano

[![Gem Version](https://badge.fury.io/rb/slackistrano.png)](http://badge.fury.io/rb/slackistrano)
[![Code Climate](https://codeclimate.com/github/supremegolf/slackistrano.png)](https://codeclimate.com/github/supremegolf/slackistrano)
[![Build Status](https://travis-ci.org/supremegolf/slackistrano.png?branch=master)](https://travis-ci.org/supremegolf/slackistrano)

Send notifications to [Slack](https://slack.com) about [Capistrano](http://www.capistranorb.com) deployments.

If you need Capistrano v2 support, check out [capistrano-slack](https://github.com/j-mcnally/capistrano-slack).

## Requirements

- Capistrano >= 3.1.0
- Ruby >= 2.0
- A Slack account

## Installation

Add this line to your application's Gemfile:

    gem 'slackistrano', require: false

And then execute:

    $ bundle

## Configuration

You have two options to notify a channel in Slack when you deploy:

 1. Using *Incoming WebHooks* integration, offering more options but requires one of the five free integrations. This is the default option.
 2. Using *Slackbot*, which will not use one of the five free integrations. Enable via the `:slack_via_slackbot` option.

In both case, you need to enable the integration inside Slack and get the token and/or webhook url that will be needed later.



Require the library in your application's Capfile:

    require 'slackistrano'

If you post using *Incoming Webhooks* you need to set your webhook url in your application's config/deploy.rb:

    set :slack_webhook, "https://hooks.slack.com/services/XXX/XXX/XXX"

If you choose to post using *Slackbot* you **must** set your team and and token in your application's config/deploy.rb:

    set :slack_via_slackbot, true
    set :slack_team, "supremegolf"
    set :slack_token, "xxxxxxxxxxxxxxxxxxxxxxxx"

Optionally, override the other slack settings:

    set :slack_icon_url,     ->{ 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
    set :slack_icon_emoji,   ->{ nil } # will override icon_url, Must be a string (ex: ':shipit:')
    set :slack_channel,      ->{ '#general' }
    set :slack_username,     ->{ 'Slackistrano' }
    set :slack_run_starting, ->{ true }
    set :slack_run_finished, ->{ true }
    set :slack_run_failed,   ->{ true }
    set :slack_msg_starting, ->{ "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}" }
    set :slack_msg_finished, ->{ "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}" }
    set :slack_msg_failed,   ->{ "#{ENV['USER'] || ENV['USERNAME']} failed to deploy branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}" }

**Note**: You may wish to disable one of the notifications if another service (ex:
Honeybadger) also displays a deploy notification.

Test your setup by running:

    $ cap production slack:deploy:starting
    $ cap production slack:deploy:finished
    $ cap production slack:deploy:failed

## Usage

Deploy your application like normal and you should see messages in the channel
you specified.

## TODO

- Notify about incorrect configuration settings.
- Notify about unsuccessfull HTTP POSTs.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
