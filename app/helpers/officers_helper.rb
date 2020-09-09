module OfficersHelper
  def format_ia_score(ia_score)
    return format_unknown if !ia_score
    text = case ia_score
           when 5
             "Most Concerning"
           when 4
             "Very Concerning"
           when 3
             "Concerning"
           when 2
             "Less Concerning"
           when 1
             "Least Concern"
           else
             "Not Concerning"
           end
    raw("<span class=\"officer__ia-score-#{ia_score}\">#{ia_score} #{text}</span>")
  end

  def format_residence(postal)
    return format_unknown if !postal
    raw("#{format_text(postal.neighborhood_or_city)}, #{format_text(postal.state)} #{format_zip(postal.zip)}")
  end
end
