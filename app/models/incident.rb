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
  has_many :swats_incidents
  has_many :swats, through: :swats_incidents
  has_and_belongs_to_many :field_contacts

  serialize :location_of_occurrence, Array
  serialize :nature_of_incident, Array
  serialize :arrests_json, Array

  before_save :populate_latitude_longitude

  counter_culture :officer

  def bag_of_text_content
    [incident_number, district, district_name, location_of_occurrence, street, nature_of_incident, officer_journal_name, incident_clearance, offenses.map(&:description).join(" "), nibrs_offenses.map(&:description).join(" "), ApplicationController.helpers.format_date_time(occurred_on_date)]
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

  # true if incident is linked to one-or-more cases or field_contacts
  def links?
    !cases.empty? || !field_contacts.empty?
  end

  def geocode!
    # location_of_occurrence.find { |l| /^((\w\d+ +)?- +)?(\d[\w-]+) +(.+)$/ =~ l }
    location = location_of_occurrence.map do |l|
      # remove district prefix "D4 - 123 XYZZY ST" -> "123 XYZZY ST"
      l = l.sub(/^[a-z]\d+ +- +/i, "")

      # remove empty district prefix "- 123 XYZZY ST" -> "123 XYZZY ST"
      l = l.sub(/^-\s+/, "")

      if /^\d.*\s/ =~ l
        l
      else
        nil
      end
    end.compact.first

    if location
      number, street = location.split(/\s+/, 2)

      # "133-A" -> "133"
      number = number.sub(/[-a-z].*/i, "")

      gc = Geocode.geocode_address(street, number)
      self.geocode_latitude = gc.latitude
      self.geocode_longitude = gc.longitude
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

  # populates lat & long before each save; prefers the coordinates geocoded
  # from the location_of_occurrence
  def populate_latitude_longitude
    if geocode_latitude && geocode_longitude && Geocode.lat_long_in_boston?(geocode_latitude, geocode_longitude)
      self.latitude = geocode_latitude
      self.longitude = geocode_longitude
    elsif reported_latitude && reported_longitude && Geocode.lat_long_in_boston?(reported_latitude, reported_longitude)
      self.latitude = reported_latitude
      self.longitude = reported_longitude
    else
      self.latitude = nil
      self.longitude = nil
    end
  end
end
