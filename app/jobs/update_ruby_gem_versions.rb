# Cycle through all gems in our database and contact Rubygems.org.
# If we're able to, we'll gather the version data. For now, this
# job cycles through the entire gems library. We may want to create
# a feature where we slowly download information... I can see the gems
# library increasing quickly.

require 'gems'

class UpdateRubyGemVersions < ApplicationJob
  def perform
    ruby_gems.each do |ruby_gem|
      response = rubygem_response(ruby_gem)
      if response.present?
        ruby_gem.push_versions(response)
        ruby_gem.save if ruby_gem.changed?
      end
    end
  end

  def ruby_gems
    RubyGemDatum.fetchable
                .all
  end

  def rubygem_response(ruby_gem)
    Gems.versions(ruby_gem.name)
  rescue => e
    if e.message.include?('This rubygem could not be found.')
      ruby_gem.update_attributes(skip: true)
    end

    nil
  end
end
