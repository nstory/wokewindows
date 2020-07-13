class Populater::FieldContactsIncidents
  def self.populate
    FieldContact.find_each do |fc|
      numbers = find_incident_numbers(fc.narrative)
      incidents = Incident.where(incident_number: numbers)
      fc.incidents = incidents
    end
  end

  private
  def self.find_incident_numbers(narrative)
    return [] if !narrative
    texts = narrative.scan(/\bI?(\d{9})\b/i).map(&:first)
    texts.map { |t| t.sub(/^I/i, "").to_i }
  end
end
