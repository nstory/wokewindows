class Complaint < ApplicationRecord
  include Attributable
  include BagOfText

  has_many :complaint_officers, dependent: :delete_all

  def bag_of_text_content
    [ia_number, summary, incident_type, complaint_officers.map(&:name), complaint_officers.map(&:allegation), finding]
  end

  # use ia_number for resource urls
  def to_param
    ia_number
  end

  def finding
    findings = complaint_officers.map(&:finding)
    return nil if findings.empty?
    uniq = findings.uniq
    return uniq.first if uniq.count == 1
    return "Partially Sustained" if uniq.include?("Sustained")
    "Mixed"
  end

  def is_preliminary?
    incident_type == "Preliminary Investigation"
  end

  def self.by_ia_number(numbers)
    Complaint.includes(:complaint_officers).where(ia_number: numbers).index_by(&:ia_number)
  end
end
