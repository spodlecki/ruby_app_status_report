class RubyGemDatumSerializer < RubyAppCheckSerializer
  def version
    instance_options[:current_version]
  end

  private

  def latest_major
    object.latest || ''
  end

  def latest_minor
    major, minor = version.split('.')
    object.latest(major: major)
  end

  def latest_patch
    major, minor = version.split('.')
    object.latest(major: major, minor: minor)
  end
end
