## App Status Report

Ever wonder how far your apps are behind on gems & ruby versions?

## Setup

`bin/setup`

## Web server

`foreman start`

## Features

* Displays Current Ruby Version compared to latest build
* Alerts major, minor, and patch versions
* Color coded dashboard from defcon 5 to defcon 1
* Processes everything in the background, update as often as you'd like
* Individual repos can be printed, copied, or downloaded

## Seeding your dev database

  REPO_NAME="Some Name" REPO_URI="git@...git" bin/rails db:seed

## Tasks for Cron

This app works off processing items in the background. Setup some cron jobs to help this along.

```
# Updates the RubyVersion Records. (0 10 * * 0) - once a week
bundle exec rake ruby_version:download

# Links Apps that are not yet synced up. (*/20 * * * *) - every 20 minutes
bundle exec rake ruby_apps:project_id

# Reads Gemfile.lock from Git API (0 */12 * * *) - every 12 hours
bundle exec rake ruby_apps:fetch_gemfile_lock

# Updates the RubyVersion Records. (0 10 * * 1) - once a week
bundle exec rake ruby_apps:fetch_ruby_version

# Updates Gem Records from active Gemfiles (50 */12 * * *) - right after the gemfile locks
bundle exec rake ruby_gems:sync_from_gemfiles

# Updates Gem Records from RubyGems.org (0 */3 * * 0,3,5) - few times a week
bundle exec rake ruby_gems:sync_from_api

# Updates Gem Records from RubyGems.org that are new to us (0 */6 * * *) - every few hours
bundle exec rake ruby_gems:fetch_new_gems
```

## Contribute

* Fork the app
* Create a feature branch
* Write code & tests
* Submit PR, let us know what you've done


## TODO / Wish list

* Add GitHub API + Write cleaner Job Code
* Update ActiveJobs to use [Resque](https://github.com/resque/resque) or [Sidekiq](https://github.com/mperham/sidekiq)
* Get an email or Slack feature where notifications could be posted
* Setup JavaScript test suite
* Setup Travis CI
