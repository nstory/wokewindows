class OfficerMatcher
  def initialize(regexp = :article_regexp)
    @regexp = regexp
  end

  # returns an array of matching officer objects. only returns
  # unambiguous matches.
  def matches(text)
    officers = regexp_to_officer.flat_map do |regexp,officer|
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
