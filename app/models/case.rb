class Case < ApplicationRecord
  include Attributable
  include BagOfText

  has_many :cases_incidents
  has_many :incidents, through: :cases_incidents

  def bag_of_text_content
    [case_number, court_name, motor_vehicle]
  end

  def court_name
    case(court)
    when "superior"
      "Superior Court"
    when /^bmc/
      "BMC " + court.sub(/^bmc_/, "").titleize
    else
      court
    end
  end

  # for drop-down on masscourts.org
  def court_department
    case(court)
    when "superior"
      "Superior Court"
    when /^bmc/
      "BMC"
    else
      "N/A"
    end
  end

  # for drop-down on masscourts.org
  def court_division
    case(court)
    when "superior"
      "Suffolk County Civil"
    when /^bmc/
      court_name
    else
      "N/A"
    end
  end

  def to_param
    "#{court}-#{case_number}"
  end
end
