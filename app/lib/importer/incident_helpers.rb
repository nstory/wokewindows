module Importer::IncidentHelpers
  def incidents_by_number(numbers)
    by_number = Hash.new { |h,k| h[k] = Incident.new }
    by_number.merge!(
      Incident.by_incident_number(numbers)
    )
    by_number
  end

  def parse_incident_number(str)
    subbed = str.sub(/^I/, "").sub(/-\d\d$/, "")
    if /^\d{7,}$/ =~ subbed
      subbed.to_i
    else
      nil
    end
  end

  def parse_string(value)
    value.blank? ? nil : value
  end
end
