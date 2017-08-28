class RubyAppCheckSerializer < ActiveModel::Serializer
  #=> abstract_class

  attributes :name,
             :version,
             :level,
             :note

  def version
    raise NoMethodError, 'Please Set #version'
  end

  def level
    if up_to_date?
      5
    elsif needs_major_update?
      1
    elsif needs_minor_update?
      2
    elsif needs_patch_update?
      3
    else
      4
    end
  end

  def note
    if up_to_date?
      'up to date'
    else
      ver = available_versions.join(', ')
      "updates; #{ver}"
    end
  end

  private

  def available_versions
    [latest_major,
     latest_minor,
     latest_patch]
    .compact
    .uniq
  end

  def latest_major
    raise NoMethodError, 'Please Set #latest_major'
  end

  def latest_minor
    raise NoMethodError, 'Please Set #latest_minor'
  end

  def latest_patch
    raise NoMethodError, 'Please Set #latest_patch'
  end

  def up_to_date?
    version == latest_major
  end

  def needs_patch_update?
    return if latest_patch.blank?
    current = parse_version(version)
    latest  = parse_version(latest_patch)

    current.major == latest.major &&
      current.minor && latest.minor &&
      current.patch < latest.patch
  end

  def needs_minor_update?
    return if latest_minor.blank?
    current = parse_version(version)
    latest  = parse_version(latest_minor)

    current.major == latest.major &&
      current.minor < latest.minor
  end

  def needs_major_update?
    return if latest_major.blank?

    current = parse_version(version)
    latest  = parse_version(latest_major)

    latest.major > current.major
  end

  def parse_version(version)
    Version.new(version)
  end

  class Version
    attr_reader :version
    def initialize(version)
      @version = version.gsub(/\-.+$/, '')
    end

    def major
      parts.first.to_i
    end

    def minor
      parts.second.to_i
    end

    def patch
      version.gsub(/\A#{major}\.#{minor}\./, '')
             .to_f
    end

    private

    def parts
      version.split('.')
    end
  end
end
