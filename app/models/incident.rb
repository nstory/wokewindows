class Incident < ApplicationRecord
  has_many :offenses
  has_many :incident_officers
  has_many :officers, through: :incident_officers

  serialize :location_of_occurrence, JSON
  serialize :nature_of_incident, JSON
  serialize :arrests_json, JSON

  def arrests=(arr)
    self.arrests_json = arr.map(&:as_json)
  end

  def arrests
    (arrests_json || []).map { |o| a = Arrest.new; a.attributes = o; a }
  end

  def self.import_incident_reports(reports)
    grouped = reports.group_by { |v| v[:incident_number] }

    grouped.values.each_slice(1000) do |slice|
      Incident.transaction do
        slice.each do |incident_list|
          first_report = incident_list.first
          Incident.create({
            incident_number: first_report[:incident_number],
            district: first_report[:district],
            reporting_area: first_report[:reporting_area],
            shooting: ["Y", "1"].include?(first_report[:shooting]),
            occurred_on_date: first_report[:occurred_on_date],
            ucr_part: first_report[:ucr_part],
            street: first_report[:street],
            latitude: first_report[:lat],
            longitude: first_report[:long],
            offenses: incident_list.map do |ir|
              Offense.new({
                code: ir[:offense_code].to_i,
                code_group: ir[:offense_code_group],
                description: ir[:offense_description]
              })
            end
          })
        end
      end
    end
  end

  def self.import_journals(journals)
    grouped = journals.group_by { |v| v[:complaint_number] }
    grouped.values.each do |lst|
      num = lst.first[:complaint_number].to_i
      inc = Incident.find_by incident_number: ["#{num}", "I#{num}"]
      if inc
        inc.location_of_occurrence = lst.pluck(:location_of_occurrence)
        inc.nature_of_incident = lst.pluck(:nature_of_incident)
        inc.incident_officers = lst.pluck(:officer).reject(&:blank?).map { |o| IncidentOfficer.new(journal_officer: o) }
        inc.arrests = lst.flat_map { |j| j.fetch(:arrests, []).map { |a| Arrest.new(a) } }
        inc.save
      else
        # puts lst.first[:complaint_number]
      end
    end
  end

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
