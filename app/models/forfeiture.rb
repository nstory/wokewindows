class Forfeiture < ApplicationRecord
  include Attributable
  has_many :forfeitures_incidents
  has_many :incidents, through: :forfeitures_incidents

  # use sucv for resource urls
  def to_param
    sucv
  end
end
