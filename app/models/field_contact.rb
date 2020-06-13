class FieldContact < ApplicationRecord
  serialize :key_situations, JSON
  has_many :field_contact_names, dependent: :delete_all
end
