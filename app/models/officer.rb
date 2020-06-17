class Officer < ApplicationRecord
  has_many :compensations
  has_many :complaint_officers
  has_many :complaints, -> { distinct }, through: :complaint_officers
  has_many :incident_officers
  has_many :incidents, through: :incident_officers
  has_many :field_contacts, foreign_key: :contact_officer_id, class_name: "FieldContact", inverse_of: :contact_officer
  has_many :supervised_field_contacts, foreign_key: :supervisor_id, class_name: "FieldContact", inverse_of: :supervisor

  def name
    if hr_name
      hr_name.sub(/,/, ", ")
    elsif journal_name
      journal_name.titleize
    else
      "Unknown"
    end
  end

  def total_earnings
    comp = compensations.find { |c| c.year == 2019 }
    comp && comp.total
  end

  # this can't be calculated with a counter cache b/c there can
  # be multiple ComplaintOfficer objects for a given Complaint
  # and Officer pair (e.g. when there are multiple allegations against
  # a given officer as part of one IA case)
  def complaints_count
    complaints.size
  end

  def title
    c = compensations.max_by(&:year)
    c ? c.title : nil
  end

  # use employee_id for resource urls
  def to_param
    employee_id.to_s
  end

  def zip_code
    c = compensations.max_by(&:year)
    c ? c.postal : nil
  end

  def self.by_employee_id
    Officer.find_each.index_by(&:employee_id)
  end
end
