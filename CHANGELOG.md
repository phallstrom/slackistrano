# Slackistrano Change Log

2.0.0
-----

- **BREAKING:** You must now `require 'slackistrano/capistrano'` in your Capfile.
  Previously it was just `require 'slackistrano'`. It is also no longer necessary
  to add `require: false` in your Gemfile, but it won't hurt to leave it.

1.1.0
-----

- Honor Capistrano's `--dry-run` [#33]
- Better error reporting if Slack API returns failure [#40]
- Allow posting to multiple channels by setting `:slack_channel` to an array [#37]


1.0.0
-----

- **BREAKING:** Renamed all `***_starting` settings to `***_updating`
- **BREAKING:** Renamed all `***_finished` settings to `***_updated`
- Added rollback options `***_reverting` and `***_reverted` [#19, #31]

