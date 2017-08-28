namespace :ruby_gems do
  task sync_from_gemfiles: [:environment] do
    CreateGemDatumFromGemfiles.perform_now
  end

  task sync_from_api: [:environment] do
    UpdateRubyGemVersions.perform_now
  end

  task fetch_new_gems: [:environment] do
    UpdateUnfetchedRubyGemVersions.perform_now
  end
end
