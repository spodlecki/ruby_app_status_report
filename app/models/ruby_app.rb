class RubyApp < ApplicationRecord
  # As we add APIs for Git providers, we'll want to add them here.
  enum api_type: {
    gitlab: 1
  }

  serialize :api_data, Hash

  validates :name,
            :repo_url,
            presence: true,
            uniqueness: true

  validates :api_type,
            presence: true

  has_one :gemfile,
          dependent: :destroy

  delegate :gems,
           to: :gemfile,
           allow_nil: true

  delegate :version,
           to: :gemfile,
           allow_nil: true,
           prefix: true

  after_initialize :setup_api_data, if: :new_record?

  def to_s
    name
  end

  def search_name
    repo_url.scan(/[^:]+:([^\/]+)\/.+/)
            .flatten
            .first
  end

  def gitlab_endpoint
    api_data.dig(:gitlab, :endpoint)
  end

  def gitlab_private_token
    api_data.dig(:gitlab, :private_token)
  end

  def gitlab_project_id
    api_data.dig(:gitlab, :project_id)
  end

  def gitlab_endpoint=(str)
    self.api_data[:gitlab][:endpoint] = str
  end

  def gitlab_private_token=(str)
    self.api_data[:gitlab][:private_token] = str
  end

  def gitlab_project_id=(id)
    self.api_data[:gitlab][:project_id] = id.to_i
  end

  def linked?
    api_data[:status]
  end

  def linked!
    self.api_data[:status] = true
    save!
  end

  def unlinked!
    self.api_data[:status] = false
    save!
  end

  private

  def setup_api_data
    self.api_data = {
      status: nil,
      gitlab: { endpoint: AppConfig.defaults['gitlab_endpoint'],
                private_token: AppConfig.defaults['gitlab_token'],
                project_id: nil }
    }
  end

end

# == Schema Information
#
# Table name: ruby_apps
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  repo_url     :string           not null
#  api_type     :integer          default("gitlab"), not null
#  api_data     :text
#  last_check   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ruby_version :string
#
