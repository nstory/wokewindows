class Officer < ApplicationRecord
  has_many :compensations
  has_many :incident_officers
  has_many :incidents, through: :incident_officers
  has_many :field_contacts, foreign_key: :contact_officer_id, class_name: "FieldContact", inverse_of: :contact_officer
  has_many :supervised_field_contacts, foreign_key: :supervisor_id, class_name: "FieldContact", inverse_of: :supervisor

  def self.by_employee_id
    Officer.find_each.index_by(&:employee_id)
  end
end
