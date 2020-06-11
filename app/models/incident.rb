class Incident < ApplicationRecord
  has_many :offenses
  serialize :location_of_occurrence, JSON
  serialize :nature_of_incident, JSON

  def self.create_from_incident_reports_and_journal_entries(incident_reports, journal_entries)
    if incident_reports.pluck(:incident_number).uniq.count > 1
      raise "incident_number must be same for all incident_reports"
    end

    first_report = incident_reports.first
    Incident.new({
      incident_number: first_report[:incident_number],
      district: first_report[:district],
      reporting_area: first_report[:reporting_area],
      shooting: ["Y", "1"].include?(first_report[:shooting]),
      occurred_on_date: first_report[:occurred_on_date],
      ucr_part: first_report[:ucr_part],
      street: first_report[:street],
      latitude: first_report[:lat],
      longitude: first_report[:long],
      offenses: incident_reports.map do |ir|
        Offense.new({
          code: ir[:offense_code].to_i,
          code_group: ir[:offense_code_group],
          description: ir[:offense_description]
        })
      end,
      location_of_occurrence: journal_entries.pluck(:location_of_occurrence),
      nature_of_incident: journal_entries.pluck(:nature_of_incident)
    })
  end
end
