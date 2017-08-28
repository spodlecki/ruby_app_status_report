class RubyVersion < ApplicationRecord
  extend SymverMatching

  validates :version,
            presence: true,
            uniqueness: true,
            format: { with: /\A[\d+\.]+\z/ }

  def self.latest_ruby(**args)
    latest(versions: versions, **args)
  end

  def self.versions
    pluck(:version).sort
                   .reverse
  end
end

# == Schema Information
#
# Table name: ruby_versions
#
#  id         :integer          not null, primary key
#  version    :string           not null
#  released   :date
#  notes_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
