module OfficersHelper
  def format_neighborhood(zip_code)
    return format_unknown if !zip_code
    "#{format_text(zip_code.neighborhood)}, #{format_text(zip_code.state)}"
  end

  def format_ia_score(ia_score)
    return format_unknown if !ia_score
    raw("<span class=\"officer__ia-score-#{ia_score}\">#{ia_score}</span>")
  end
end
