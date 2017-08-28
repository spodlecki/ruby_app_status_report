# Reads all of the gem files we have on file, and creates
# records for the RubyGemDatum model. We do not create duplicates.
# note; This file can probably be sped up by not using ActiveRecord.
class CreateGemDatumFromGemfiles < ApplicationJob
  def perform
    # Purge Gems We Don't Use
    if gems.any?
      RubyGemDatum.where
                  .not(name: gems)
                  .delete_all
    end

    # Make sure we've added all gems we do use
    import
  end

  def gemfiles
    @gemfiles ||= Gemfile.all
  end

  def gems
    @gems ||= gemfiles.map(&:gems)
                      .flatten
                      .uniq
                      .sort
  end

  def import
    gems.each do |g|
      RubyGemDatum.find_or_create_by(name: g)
    end
  end
end
