class Incident < ApplicationRecord
  has_many :offenses
  has_many :incident_officers, dependent: :delete_all
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
end
