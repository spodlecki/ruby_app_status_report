require 'bundler'

class Gemfile < ApplicationRecord
  serialize :data, Hash

  validates :ruby_app_id,
            presence: true

  belongs_to :ruby_app, touch: true

  def self.parse(text)
    gems     = {}
    lockfile = Bundler::LockfileParser.new(text)
    lockfile.specs.each do |s|
      gems.merge!({ s.name.downcase => s.version.to_s })
    end
    gems
  end

  def gems
    data.keys
        .sort
  end

  def version(gem_name)
    data[gem_name.to_s]
  end

  def parse_gemfile_lock(text)
    self.data = self.class.parse(text)
  end
end

# == Schema Information
#
# Table name: gemfiles
#
#  id          :integer          not null, primary key
#  ruby_app_id :integer          not null
#  data        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
