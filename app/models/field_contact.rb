class FieldContact < ApplicationRecord
  serialize :key_situations, JSON

  belongs_to :contact_officer, foreign_key: :contact_officer_id, class_name: "Officer", optional: true, inverse_of: :field_contacts
  belongs_to :supervisor, foreign_key: :supervisor_id, class_name: "Officer", optional: true
  has_many :field_contact_names, dependent: :delete_all
end
