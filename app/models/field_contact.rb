class FieldContact < ApplicationRecord
  include Attributable
  include BagOfText

  serialize :key_situations, JSON

  belongs_to :contact_officer, foreign_key: :contact_officer_id, class_name: "Officer", optional: true, inverse_of: :field_contacts
  belongs_to :supervisor, foreign_key: :supervisor_id, class_name: "Officer", optional: true
  has_many :field_contact_names, dependent: :delete_all
  has_and_belongs_to_many :incidents
  has_and_belongs_to_many :citations

  counter_culture :contact_officer

  def bag_of_text_content
    [fc_num, contact_officer_name, supervisor_name, street, city, state, frisked_searched, stop_duration, circumstance, basis, vehicle_state, vehicle_make, vehicle_model, vehicle_color, vehicle_style, vehicle_type, key_situations, narrative, weather]
  end

  # use fc_num for resource urls
  def to_param
    fc_num
  end
end
