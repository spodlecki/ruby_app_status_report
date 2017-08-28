# bundle exec rails db:seed

app = RubyApp.find_or_create_by!(name: ENV['REPO_NAME'],
                                 repo_url: ENV['REPO_URI'])

# Ruby App
ApplyRubyAppProjectId.perform_now(app.id)
UpdateRubyAppGems.perform_now(app.id)
UpdateRubyAppVersion.perform_now(app.id)

# Ruby Gem Data
UpdateRubyGemVersions.perform_now
