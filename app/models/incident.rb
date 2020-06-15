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

  def self.by_incident_number(numbers)
    Incident.where(incident_number: numbers)
      .index_by(&:incident_number)
  end
end
