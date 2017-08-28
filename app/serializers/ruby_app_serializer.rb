class RubyAppSerializer < ActiveModel::Serializer
  attributes :id,
             :status,
             :name,
             :updated_at,
             :items,
             :errors

  def status
    object.linked?
  end

  def items
    return if object.new_record?
    @items ||= ruby_version_serialized +
               ruby_gems_serialized
  end

  def updated_at
    return if object.new_record?
    object.updated_at&.utc.to_s
  end

  def errors
    object.errors.full_messages
  end
  private

  def ruby_version_serialized
    return [] if object.ruby_version.blank?
    options = instance_options.merge(scope: scope)
    [RubyAppVersionSerializer.new(object, options)]
  end

  def ruby_gems_serialized
    @rgs ||= ruby_gems.map do |ruby_gem|
      options = instance_options.merge(
        scope: scope,
        current_version: object.gemfile_version(ruby_gem)
      )
      RubyGemDatumSerializer.new(ruby_gem, options)
    end
  end

  def ruby_gems
    @ruby_gems ||= RubyGemDatum.fetchable
                               .where(name: object.gems)
  end
end
