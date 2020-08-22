# an Attribution object links a record to a source document from which it
# was imported. a given record may have multiple Attributions
class Attribution
  include ActiveModel::Model

  FRIENDLY_MAPPING = {
    "district_journal" => "Public Journal",
    "crime_incident_reports" => "Crime Incident Reports",
    "nibrs_incident_reports" => "NIBRS Incident Reports",
    "field_contact" => "FIO Records FieldContact Table",
    "field_contact_name" => "FIO Records FieldContact_Name Table",
    "employee_earnings" => "Employee Earnings Report",
    "cy2015_annual_earnings" => "BPD CY2015 Annual Earnings File",
    "alpha_listing" => "BPD Alpha Listing with Badges",
    "2014_officer_ia_log" => "2014 Officer IA Log",
    "bpd_ia_data_2001_2011" => "BPD IA Data 2001 - 2011",
    "da_forfeitures" => "Forfeitures by Suffolk District Attorney",
    "swat" => "SWAT Reports",
    "detail_records" => "Detail Records 2019",
    "2019_tickets" => "2019 Traffic Tickets",
    "bpd_fio_data" => "BPD FIO Data",
    "alpha_listing_20200715" => "2020 Alpha Listing"
  }

  attr_accessor :filename, :category, :url
  validates :filename, :category, presence: true, strict: true

  def ==(o)
    o.class == self.class && o.attributes == self.attributes
  end
  alias_method :eql?, :==

  def hash
    attributes.hash
  end

  def attributes
    {"filename" => filename, "category" => category, "url" => url}
  end

  def friendly_category
    FRIENDLY_MAPPING.fetch(category, category)
  end
end
