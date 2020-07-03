module SwatsHelper
  def format_swats_incidents(swats_incidents)
    return format_unknown if swats_incidents.blank?
    parts = swats_incidents.map do |si|
      if si.incident
        link_to si.incident_number, incident_path(si.incident)
      else
        si.incident_number
      end
    end
    safe_join parts, ", "
  end

  def format_swats_officers(swats_officers)
    return format_unknown if swats_officers.blank?
    parts = swats_officers.sort_by { |so| so.officer_name }.map do |so|
      if so.officer
        link_to so.officer_name, officer_path(so.officer)
      else
        so.officer_name
      end
    end
    safe_join parts, "; "
  end
end
