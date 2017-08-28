class RubyAppsController < ApplicationController
  def index
    models = RubyApp.order(name: :asc)
    render json: models,
           each_serializer: RubyAppSerializer,
           excludes: ['checks']
  end

  def show
    model = RubyApp.find_by! id: params[:id]
    render json: model,
           serializer: RubyAppSerializer
  end

  def create
    model = RubyApp.new(app_params.merge(gitlab_params))
    model.save

    render json: model,
           serializer: RubyAppSerializer,
           meta: { errors: model.errors.full_messages }
  end

  private

  def app_params
    params.permit(:name, :repo_url)
  end

  def gitlab_params
    return {} unless include_gitlab_config?
    params.permit(:gitlab_endpoint, :gitlab_private_token)
  end

  def include_gitlab_config?
    params[:gitlab_endpoint].present? &&
      params[:gitlab_private_token].present?
  end
end
