# Gather up a specific RubyApp record by an ID, and then fetch the
# Gemfile.lock file from the Gitlab API. We then apply it to the record
# and parse it.

require 'gitlab'

class UpdateRubyAppGems < ApplicationJob
  def perform(app_id)
    @app                  = RubyApp.find_by!(id: app_id)

    Gitlab.endpoint       = app.gitlab_endpoint
    Gitlab.private_token  = app.gitlab_private_token
    content               = fetch_gemfile_content
    model                 = (app.gemfile || app.build_gemfile)
    model.parse_gemfile_lock(content)
    model.save!
  end

  private

  def app
    @app
  end

  # note; Unable to use Gitlab Gem
  # Any file with an extension is not url encoded (. -> %2E)
  # https://gitlab.com/gitlab-org/gitlab-ce/issues/31470
  def fetch_gemfile_content
    path = "/projects/#{app.gitlab_project_id.to_i}/"\
           'repository/files/Gemfile%2Elock/raw'
    Gitlab.get(path,
               query: { ref: 'master'},
               format: nil,
               headers: { Accept: 'text/plain' },
               parser: ::Gitlab::Request::Parser)
  end
end
