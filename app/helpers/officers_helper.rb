module OfficersHelper
  def format_ia_score(ia_score)
    return format_unknown if !ia_score
    raw("<span class=\"officer__ia-score-#{ia_score}\">#{ia_score}</span>")
  end

  def format_residence(postal)
    return format_unknown if !postal
    "#{format_text(postal.neighborhood)}, #{format_text(postal.state)} #{format_zip(postal.zip)}"
  end
end
