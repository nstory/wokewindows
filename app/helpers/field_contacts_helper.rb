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

  def format_narrative(field_contact)
    return format_unknown if field_contact.narrative.blank?
    incidents = field_contact.incidents.to_a
    raw(simple_format(field_contact.narrative).gsub(/I?(\d{9})/i) do |text|
      inc_num = $1.to_i
      incident = incidents.find { |i| i.incident_number == inc_num }
      if incident
        link_to text, incident_path(incident)
      else
        text
      end
    end)
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
