class Incident < ApplicationRecord
  include Attributable
  include Offenses
  include BagOfText

  DISTRICT_TO_NAME_MAPPING = {
    "A1" => "Downtown",
    "A15" => "Charlestown",
    "A7" => "East Boston",
    "B2" => "Roxbury",
    "B3" => "Mattapan",
    "C6" => "South Boston",
    "C11" => "Dorchester",
    "D4" => "South End",
    "D14" => "Brighton",
    "E5" => "West Roxbury",
    "E13" => "Jamaica Plain",
    "E18" => "Hyde Park"
  }

  belongs_to :officer, optional: true
  has_many :cases_incidents
  has_many :cases, through: :cases_incidents

  serialize :location_of_occurrence, Array
  serialize :nature_of_incident, Array
  serialize :arrests_json, Array

  counter_culture :officer

  def bag_of_text_content
    [district, district_name, location_of_occurrence, street, nature_of_incident, officer_journal_name, offenses.map(&:description).join(" ")]
  end

  def arrests=(arr)
    self.arrests_json = arr.map(&:as_json)
  end

  def arrests
    (arrests_json || []).map { |o| a = Arrest.new; a.attributes = o; a }
  end

  def district_name
    DISTRICT_TO_NAME_MAPPING[district]
  end

  # use incident_number for resource urls
  def to_param
    incident_number.to_s
  end

  # parses officer_journal_name
  def officer_journal_name_id
    if matches = match_journal_name_regexp
      matches[1].to_i
    else
      nil
    end
  end

  # parses officer_journal_name
  def officer_journal_name_name
    if matches = match_journal_name_regexp
      matches[2].strip
    else
      nil
    end
  end

  def self.by_incident_number(numbers)
    Incident.where(incident_number: numbers)
      .index_by(&:incident_number)
  end

  private
  def match_journal_name_regexp
    /^(\d{4,})  (.+)+$/.match(officer_journal_name)
  end
end
