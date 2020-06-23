class Complaint < ApplicationRecord
  include Attributable
  include BagOfText

  has_many :complaint_officers, dependent: :delete_all

  def bag_of_text_content
    [ia_number, summary, incident_type, complaint_officers.map(&:name)]
  end

  # use ia_number for resource urls
  def to_param
    ia_number
  end

  def self.by_ia_number(numbers)
    Complaint.where(ia_number: numbers).index_by(&:ia_number)
  end
end
