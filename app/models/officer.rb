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
  has_many :swats_officers
  has_many :swats, through: :swats_officers
  has_many :details
  has_many :citations
  has_many :articles_officers

  def bag_of_text_content
    [name, title, postal, zip_code && zip_code.state, zip_code && zip_code.neighborhood]
  end

  def last_name_regexp
    Regexp.new(hr_name.sub(/,.*/, "").gsub(/[^a-z]/i, ".?"), Regexp::IGNORECASE)
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
