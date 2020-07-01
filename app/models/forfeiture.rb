class Forfeiture < ApplicationRecord
  include Attributable
  has_many :forfeitures_incidents
  has_many :incidents, through: :forfeitures_incidents

  # converts old-style case number e.g. 2015-2781G into new-style: 1584CV02781
  # assumes this is a civil case in suffolk superior
  # https://www.mass.gov/doc/superior-court-case-numbering-format/download
  def new_style_case_number
    if /^(\d{4})-(\d+)/.match(sucv)
      year = $1
      num = $2
      return "#{year.to_i - 2000}84CV#{num.rjust(5, "0")}"
    end

    if sucv.gsub("-", "").length == 11
      return sucv.gsub("-", "")
    end

    return nil
  end

  # use sucv for resource urls
  def to_param
    sucv
  end
end
