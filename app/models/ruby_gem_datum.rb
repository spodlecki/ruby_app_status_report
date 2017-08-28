# Class is used to store rubygems.org data, versions specifically.
# Down the road, we can possibly store date & times as this could
# be turns into a red flag as well. If the gem has not been maintained
# or released for X amount of time, alert the dashboard.

class RubyGemDatum < ApplicationRecord
  extend SymverMatching
  validates :name,
            presence: true,
            uniqueness: true

  serialize :versions, Array

  scope :fetchable, -> { where(skip: false) }
  scope :unfetched, -> { fetchable.where(versions: []) }

  def to_s
    name
  end

  def push_versions(new_versions)
    new_versions.each do |v|
      push_version(v.with_indifferent_access)
    end
  end

  def latest(**args)
    self.class.latest(versions: versions, **args)
  end

  private

  def push_version(version)
    return if version[:prerelease]
    self.versions << version[:number]
    self.versions = versions.sort
                            .reverse
                            .uniq
  end
end

# == Schema Information
#
# Table name: ruby_gem_data
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  versions   :text
#  skip       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
