module ComplaintsHelper
  def format_complaint_officer(co)
    if co.officer
      link_to co.name, co.officer
    else
      format_text(co.name)
    end
  end

  def format_summary(summary)
    return format_unknown if !summary
    simple_format(summary)
  end
end
