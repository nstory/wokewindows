class Swat < ApplicationRecord
  include Attributable

  has_many :swats_incidents
  has_many :incidents, through: :swats_incidents
  has_many :swats_officers
  has_many :officers, through: :swats_officers

  # counter_culture [:swats_officers, :officer]

  def pdf_url
    "https://wokewindows-data.s3.amazonaws.com/swats/#{swat_number}.pdf"
  end

  def to_param
    swat_number
  end
end
