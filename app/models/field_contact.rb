class FieldContact < ApplicationRecord
  include Attributable
  include BagOfText

  serialize :key_situations, JSON

  enum stop_duration: {
    fifteen_to_twenty_minutes: "fifteen_to_twenty_minutes",
    five_to_ten_minutes: "five_to_ten_minutes",
    forty_five_to_sixty_minutes: "forty_five_to_sixty_minutes",
    less_than_five_minutes: "less_than_five_minutes",
    longer_than_two_hours: "longer_than_two_hours",
    one_to_two_hours: "one_to_two_hours",
    ten_to_fifteen_minutes: "ten_to_fifteen_minutes",
    thirty_to_forty_five_minutes: "thirty_to_forty_five_minutes",
    twenty_to_twenty_five_minutes: "twenty_to_twenty_five_minutes",
    twenty_five_to_thirty_minutes: "twenty_five_to_thirty_minutes"
  }

  enum basis: {
    encounter: "encounter",
    intel: "intel",
    probable_cause: "probable_cause",
    reasonable_suspicion: "reasonable_suspicion"
  }

  enum circumstance: {
    circumstance: "circumstance",
    encountered: "encountered",
    observed: "observed",
    stopped: "stopped"
  }

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
