module ForfeituresHelper
  def format_forfeitures_incidents(fis)
    return format_unknown if fis.empty?
    parts = fis.map do |fi|
      if fi.incident
        link_to(fi.incident_number, incident_path(fi.incident))
      else
        fi.incident_number
      end
    end
    safe_join(parts, ", ")
  end
end
