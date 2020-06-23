class Officer < ApplicationRecord
  include Attributable
  include BagOfText

  has_many :compensations
  has_many :complaint_officers
  has_many :complaints, -> { distinct }, through: :complaint_officers
  has_many :incidents
  has_many :field_contacts, foreign_key: :contact_officer_id, class_name: "FieldContact", inverse_of: :contact_officer
  has_many :supervised_field_contacts, foreign_key: :supervisor_id, class_name: "FieldContact", inverse_of: :supervisor
  belongs_to :zip_code, foreign_key: :postal, primary_key: :zip, optional: true

  def bag_of_text_content
    [name, title, zip_code && zip_code.state, zip_code && zip_code.city]
  end

  def name
    if hr_name
      hr_name.sub(/,/, ", ")
    elsif journal_name
      journal_name.titleize
    else
      "Unknown"
    end
  end

  # use employee_id for resource urls
  def to_param
    employee_id.to_s
  end

  def self.by_employee_id
    Officer.find_each.index_by(&:employee_id)
  end
end
