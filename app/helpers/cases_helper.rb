module CasesHelper
  def format_cases_incidents(cis)
    return format_unknown if cis.empty?
    parts = cis.map do |ci|
      if ci.incident
        link_to(ci.incident_number, incident_path(ci.incident))
      else
        ci.incident_number
      end
    end
    safe_join(parts, ", ")
  end
end
