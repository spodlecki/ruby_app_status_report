require 'gitlab'

# Gets the RubyApp in sync with the end point (Gitlab)
# by gathering the Project ID. This Project ID helps with the API
# commands and speeds things up for us.
class ApplyRubyAppProjectId < ApplicationJob
  def perform(app_id)
    app                   = RubyApp.find_by! id: app_id
    Gitlab.endpoint       = app.gitlab_endpoint
    Gitlab.private_token  = app.gitlab_private_token
    project_id            = search_from_url(app)
    project_id            = cycle_all_projects(project_id, app)

    if project_id.present?
      app.gitlab_project_id = project_id
      app.linked!
    else
      app.unlinked!
    end
  end

  def search_from_url(app)
    project_id  = nil
    name        = app.search_name
    results     = Gitlab.project_search(name)

    return if results.blank?

    results.each do |result|
      if result.ssh_url_to_repo == app.repo_url
        project_id = result.id
        break
      end
    end

    project_id
  end

  def cycle_all_projects(project_id, app)
    return project_id if project_id.present?
    projects = Gitlab.projects(per_page: 100)
    projects.auto_paginate do |project|
      if result.ssh_url_to_repo == app.repo_url
        project_id = result.id
        break
      end
    end

    project_id
  end
end
