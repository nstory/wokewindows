class Detail < ApplicationRecord
  include Attributable
  include BagOfText

  belongs_to :officer, optional: true

  counter_culture :officer

  def bag_of_text_content
    [tracking_no, employee_name, customer_name, address, ApplicationController.helpers.format_date_time(start_date_time), detail_type_friendly]
  end

  def address
    return "#{street_no} #{street}" if street_no && street
    return "#{street} & #{xstreet}" if street && xstreet
    return street
  end

  def detail_type_friendly
    case(detail_type)
    when "C"
      "Construction"
    when "S"
      "Security"
    else
      nil
    end
  end

  def geocode!
    if street && street_no
      gc = Geocode.geocode_address(street, street_no)
      self.latitude = gc.latitude
      self.longitude = gc.longitude
    elsif street && xstreet
      gc = Geocode.geocode_intersection(street, xstreet)
      self.latitude = gc.latitude
      self.longitude = gc.longitude
    end
  end

  def to_param
    tracking_no.to_s
  end
end
