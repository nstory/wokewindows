module IncidentsHelper
  def format_cases(cases)
    return format_unknown if cases.empty?
    links = cases.map { |f| link_to f.case_number, case_path(f) }
    safe_join links, ", "
  end

  def format_field_contacts(field_contacts)
    return format_unknown if field_contacts.empty?
    links = field_contacts.map { |fc| link_to fc.fc_num, field_contact_path(fc) }
    safe_join links, ", "
  end

  def format_lat_long(lat, long)
    if !lat || !long
      return format_unknown
    end
    "(#{lat}, #{long})"
  end

  def format_incident_officer(incident)
    return format_unknown if incident.officer_journal_name.blank?
    if incident.officer
      link_to(incident.officer_journal_name, officer_path(incident.officer))
    else
      incident.officer_journal_name
    end
  end

  def format_shooting(bool)
    if bool == nil
      return format_unknown
    end
    bool ? raw('<span class="text-danger">Yes</span>') : "No"
  end
end
