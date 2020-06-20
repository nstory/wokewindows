module IncidentsHelper
  def format_lat_long(lat, long)
    if !lat || !long
      return format_unknown
    end
    "(#{lat}, #{long})"
  end

  def format_incident_officers(ios)
    items = ios.map do |io|
      if io.officer
        link_to(io.journal_officer, officer_path(io.officer))
      else
        io.journal_officer
      end
    end
    safe_join(items, ", ")
  end

  def format_shooting(bool)
    if bool == nil
      return format_unknown
    end
    bool ? raw('<span class="text-danger">Yes</span>') : "No"
  end
end
