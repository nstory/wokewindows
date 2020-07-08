class Detail < ApplicationRecord
  include Attributable
  include BagOfText

  belongs_to :officer, optional: true

  counter_culture :officer

  def bag_of_text_content
    [tracking_no, employee_name, customer_name, address, ApplicationController.helpers.format_date_time(start_date_time)]
  end

  def address
    return "#{street_no} #{street}" if street_no && street
    return "#{street} & #{xstreet}" if street && xstreet
    return street
  end

  def to_param
    tracking_no.to_s
  end
end
