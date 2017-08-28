class RubyAppVersionSerializer < RubyAppCheckSerializer
  def version
    object.ruby_version
  end

  def name
    'Ruby'
  end

  private

  def latest_major
    RubyVersion.latest_ruby || ''
  end

  def latest_minor
    major, minor = version.split('.')
    RubyVersion.latest_ruby(major: major)
  end

  def latest_patch
    major, minor = version.split('.')
    RubyVersion.latest_ruby(major: major, minor: minor)
  end
end
