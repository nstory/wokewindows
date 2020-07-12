module CitationsHelper
  def format_citation_officer(citation)
    return format_unknown if !citation.officer_number
    if citation.officer
      link_to "#{citation.officer.name} (#{citation.officer_number})", officer_path(citation.officer)
    else
      format_text(citation.officer_number)
    end
  end
end
