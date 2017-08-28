# Module used to find latest versions OR
# latest versions based on a MAJOR.MINOR.PATCH
module SymverMatching
  def latest(versions:, major: nil, minor: nil, patch: nil)
    available = if major
                  versions.select do |ver|
                    matched?(version: ver,
                             major: major,
                             minor: minor,
                             patch: patch)
                  end
                else
                  versions
                end

    available.sort
             .reverse
             .first
  end

  private

  def matched?(version:, major:, minor:, patch:)
    minor   ||= '[0-9]+'
    patch   ||= '[0-9]+'
    regexp    = %r{\A#{major}\.#{minor}\.#{patch}(\..+)?}
    version.match?(regexp)
  end
end
