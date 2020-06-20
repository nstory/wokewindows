class Complaint < ApplicationRecord
  include Attributable

  has_many :complaint_officers, dependent: :delete_all

  def self.by_ia_number(numbers)
    Complaint.where(ia_number: numbers).index_by(&:ia_number)
  end
end
