module OfficersHelper
  def format_neighborhood(zip_code)
    return format_unknown if !zip_code
    "#{format_text(zip_code.neighborhood)}, #{format_text(zip_code.state)}"
  end
end
