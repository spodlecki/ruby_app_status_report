namespace :ruby_apps do
  task project_id: [:environment] do
    RubyApp.all.each do |app|
      next if app.linked?
      ApplyRubyAppProjectId.perform_now(app.id)
    end
  end

  task fetch_gemfile_lock: [:environment] do
    RubyApp.all.each do |app|
      UpdateRubyAppGems.perform_now(app.id)
    end
  end

  task fetch_ruby_version: [:environment] do
    RubyApp.all.each do |app|
      UpdateRubyAppVersion.perform_now(app.id)
    end
  end
end
