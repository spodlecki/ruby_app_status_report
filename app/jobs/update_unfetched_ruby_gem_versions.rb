# When a new app is added, it is likely that we'll have gems that don't have
# information on their records. We'll want to get this job to run more often
# so we can update those records quickly. Once they have data, we can go back
# to updating only during specific days.

require 'gems'

class UpdateUnfetchedRubyGemVersions < UpdateRubyGemVersions
  def ruby_gems
    RubyGemDatum.unfetched
                .all
  end
end
