module FieldContactsHelper
  def format_contact_officer(field_contact)
    format_officer(
      field_contact.contact_officer_name,
      field_contact.contact_officer
    )
  end

  def format_supervisor(field_contact)
    format_officer(
      field_contact.supervisor_name,
      field_contact.supervisor
    )
  end

  def format_narrative(narrative)
    return format_unknown if narrative.blank?
    simple_format(narrative)
  end

  private
  def format_officer(name, officer)
    if officer
      link_to(name, officer_path(officer))
    else
      name
    end
  end
end
