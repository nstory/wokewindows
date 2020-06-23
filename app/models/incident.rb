class Incident < ApplicationRecord
  include Attributable
  include Offenses
  include BagOfText

  belongs_to :officer, optional: true

  serialize :location_of_occurrence, Array
  serialize :nature_of_incident, Array
  serialize :arrests_json, Array

  counter_culture :officer

  def bag_of_text_content
    [district, location_of_occurrence, street, nature_of_incident, officer_journal_name, offenses.map(&:description).join(" ")]
  end

  def arrests=(arr)
    self.arrests_json = arr.map(&:as_json)
  end

  def arrests
    (arrests_json || []).map { |o| a = Arrest.new; a.attributes = o; a }
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
