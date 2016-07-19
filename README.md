aaa# Slackistrano

[![Gem Version](https://badge.fury.io/rb/slackistrano.png)](http://badge.fury.io/rb/slackistrano)
[![Code Climate](https://codeclimate.com/github/phallstrom/slackistrano.png)](https://codeclimate.com/github/phallstrom/slackistrano)
[![Build Status](https://travis-ci.org/phallstrom/slackistrano.png?branch=master)](https://travis-ci.org/phallstrom/slackistrano)

Send notifications to [Slack](https://slack.com) about [Capistrano](http://www.capistranorb.com) deployments.

## Requirements

- Capistrano >= 3.5.0
- Ruby >= 2.0
- A Slack account

## Installation

1. Add this line to your application's Gemfile:

   ```
   gem 'slackistrano'
   ```

2. Execute:

       $ bundle

3. Require the library in your application's Capfile:

       require 'slackistrano/capistrano'

## Configuration

You have two options to notify a channel in Slack when you deploy:

1. Using *Incoming WebHooks* integration, offering more options but requires
   one of the five free integrations. This option provides more messaging
   flexibility.
2. Using *Slackbot*, which will not use one of the five free integrations.

### Incoming Webhook

1. Configure your Slack's Incoming Webhook.
2. Add the following to `config/deploy.rb`:

       set :slackistrano, {
         channel: '#your-channel',
         webhook: 'your-incoming-webhook-url'
       }

### Slackbot

1. Configure your Slack's Slackbot (not Bot).
2. Add the following to `config/deploy.rb`:

       set :slackistrano, {
         channel: '#your-channel',
         team: 'your-team-name',
         token: 'your-token'
       }

### Test your Configuration

Test your setup by running the following command. This will post each stage's
message to Slack in turn.

    $ cap production slack:deploy:test

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
