module AppealsHelper
  def render_appeal_decision_excerpt(appeal, search)
    radius = 250

    # N/A if no decision
    return format_unknown if appeal.decisions_text.blank?

    # break search into words and phrases, and hackily blank out stuff
    # that's not useful to highlight
    sanitized = search.gsub(/\b(and|or)\b/i, " ")
    sanitized = sanitized.gsub(/set\?/, " ")
    sanitized = sanitized.sub(/custodian ~ [^ ]+/, " ")
    words = sanitized.scan(/"[^"]+"|\w+/)
    words.map! { |w| w.gsub(/"/, "") }
    words.reject!(&:blank?)

    # just return the beginning if there's no search
    return truncate(appeal.decisions_text, length: radius*2) if words.empty?

    re = Regexp.new(words.map { |w| Regexp.escape(w) }.join("|"), Regexp::IGNORECASE)
    cerpt = excerpt(appeal.decisions_text, re, radius: radius)
    ret = highlight(cerpt, re)
    return truncate(appeal.decisions_text, length: radius*2) if ret.blank?
    ret
  end
end
