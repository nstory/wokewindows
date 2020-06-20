module ComplaintsHelper
  def format_complaint_officer(co)
    if co.officer
      link_to co.name, co.officer
    else
      format_text(co.name)
    end
  end
end
