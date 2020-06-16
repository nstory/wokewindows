class Complaint < ApplicationRecord
  has_many :complaint_officers

  def self.by_ia_number(numbers)
    Complaint.where(ia_number: numbers).index_by(&:ia_number)
  end
end
