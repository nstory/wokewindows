class OfficerMatcher
  def initialize(regexp = :article_regexp)
    @regexp = regexp
  end

  # returns an array of matching officer objects. only returns
  # unambiguous matches.
  def matches(text, max_start_date: nil)
    rto = regexp_to_officer

    if max_start_date
      rto = rto.select do |re, o|
        if o.doa
          # only if officer hired on-or-before max_start_date
          Date.iso8601(o.doa) <= max_start_date
        else
          true
        end
      end
    end

    officers = rto.flat_map do |regexp,officer|
      text.scan(regexp).map { |m| [m, officer] }.uniq
    end.group_by(&:first)
      .select { |k,v| v.count == 1 }
      .map { |k,v| v.first.second }
      .uniq
    officers
  end

  private
  def regexp_to_officer
    @regexp_to_officer ||= Officer.where("hr_name IS NOT NULL").map { |o| [o.send(@regexp), o] }
  end
end
