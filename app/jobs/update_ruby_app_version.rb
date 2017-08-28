# Gather up a specific RubyApp record by an ID, and then fetch the
# .ruby-version file from the Gitlab API. We then apply it to the record
# and we'll be able to compare versions.

require 'gitlab'

class UpdateRubyAppVersion < ApplicationJob
  def perform(app_id)
    @app                  = RubyApp.find_by!(id: app_id)
    Gitlab.endpoint       = app.gitlab_endpoint
    Gitlab.private_token  = app.gitlab_private_token
    content               = fetch_ruby_version_content
    app.update_attributes(ruby_version: content.strip)
  end

  private

  def app
    @app
  end

  # note; Unable to use Gitlab Gem
  # Any file with an extension is not url encoded (. -> %2E)
  # https://gitlab.com/gitlab-org/gitlab-ce/issues/31470
  def fetch_ruby_version_content
    path = "/projects/#{app.gitlab_project_id.to_i}/"\
           'repository/files/%2Eruby-version/raw'
    Gitlab.get(path,
               query: { ref: 'master'},
               format: nil,
               headers: { Accept: 'text/plain' },
               parser: ::Gitlab::Request::Parser)
  end
end
