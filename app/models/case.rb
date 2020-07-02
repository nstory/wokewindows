class Case < ApplicationRecord
  include Attributable
  include BagOfText

  has_many :cases_incidents
  has_many :incidents, through: :cases_incidents

  def bag_of_text_content
    [case_number, court_name, motor_vehicle]
  end

  def court_name
    return "Superior Court" if court == "superior"
    court
  end

  def to_param
    "#{court}-#{case_number}"
  end
end
