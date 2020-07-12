class Citation < ApplicationRecord
  include Attributable
  include CitationOffenses
  include BagOfText

  belongs_to :officer, optional: true

  counter_culture :officer

  def bag_of_text_content
    [ticket_number, officer ? officer.name : "", ApplicationController.helpers.format_date_time(event_date), issuing_agency, location_name, ticket_type, source, violator_type, license_class, radar, clocked, race, sex, make, model_year, vehicle_color, court_name, offenses.map(&:description)]
  end

  def court_name
    COURT_MAPPING.fetch(court_code, court_code)
  end

  def to_param
    ticket_number
  end

  COURT_MAPPING = {
    "CT_001" => "BMC Central",
    "CT_002" => "Roxbury BMC",
    "CT_003" => "South Boston BMC",
    "CT_004" => "Charlestown BMC",
    "CT_005" => "East Boston BMC",
    "CT_006" => "West Roxbury BMC",
    "CT_007" => "Dorchester BMC",
    "CT_008" => "Brighton BMC",
    "CT_009" => "Brookline District Court",
    "CT_010" => "Somerville District Court",
    "CT_011" => "Lowell District Court",
    "CT_012" => "Newton District Court",
    "CT_013" => "Lynn District Court",
    "CT_014" => "Chelsea District Court",
    "CT_015" => "Brockton District Court",
    "CT_016" => "Fitchburg District Court",
    "CT_017" => "Holyoke District Court",
    "CT_018" => "Lawrence District Court",
    "CT_020" => "Chicopee District Court",
    "CT_021" => "Marlboro District Court",
    "CT_022" => "Newburyport District Court",
    "CT_023" => "Springfield District Court",
    "CT_025" => "Barnstable District Court",
    "CT_026" => "Orleans District Court",
    "CT_027" => "Pittsfield District Court",
    "CT_028" => "Northern Berkshire District Court",
    "CT_029" => "Southern Berkshire District Court",
    "CT_031" => "Taunton District Court",
    "CT_032" => "Fall River District Court",
    "CT_033" => "New Bedford District Court",
    "CT_034" => "Attleboro District Court",
    "CT_035" => "Edgartown District Court",
    "CT_036" => "Salem District Court",
    "CT_038" => "Haverhill District Court",
    "CT_039" => "Gloucester District",
    "CT_040" => "Ipswich District Court",
    "CT_041" => "Greenfield District Court",
    "CT_042" => "Orange District Court",
    "CT_043" => "Palmer District Court",
    "CT_044" => "Westfield District Court",
    "CT_045" => "Northampton District Court",
    "CT_047" => "Concord District Court",
    "CT_048" => "Ayer District Court",
    "CT_049" => "Framingham District Court",
    "CT_050" => "Malden District Court",
    "CT_051" => "Waltham District Court",
    "CT_052" => "Cambridge District Court",
    "CT_053" => "Woburn District Court",
    "CT_054" => "Dedham District Court",
    "CT_055" => "Stoughton District Court",
    "CT_056" => "Quincy District Court",
    "CT_057" => "Wrentham District Court",
    "CT_058" => "Hingham District Court",
    "CT_059" => "Plymouth District Court",
    "CT_060" => "Wareham District Court",
    "CT_061" => "Leominster District Court",
    "CT_062" => "Worcester District Court",
    "CT_063" => "Gardner District Court",
    "CT_064" => "Dudley District Court",
    "CT_065" => "Uxbridge District Court",
    "CT_066" => "Milford District Court",
    "CT_067" => "Westborough District Court",
    "CT_068" => "Clinton District Court",
    "CT_069" => "East Brookfield District Court",
    "CT_070" => "Winchendon District Court",
    "CT_071" => "Suffolk Juvenile",
    "CT_072" => "Barnstable Superior Court",
    "CT_073" => "Bristol Superior Court",
    "CT_074" => "Dukes Superior Court",
    "CT_075" => "Nantucket Superior Court",
    "CT_076" => "Berkshire Superior Court",
    "CT_077" => "Essex Superior Court",
    "CT_078" => "Franklin Superior Court",
    "CT_079" => "Hampden Superior Court",
    "CT_080" => "Hampshire Superior Court",
    "CT_081" => "Middlesex Superior Court",
    "CT_082" => "Norfolk Superior Court",
    "CT_083" => "Plymouth Superior Court",
    "CT_084" => "Suffolk Superior Court",
    "CT_085" => "Worcester Superior Court",
    "CT_086" => "Peabody District Court",
    "CT_087" => "Natick District Court",
    "CT_088" => "Nantucket District Court",
    "CT_089" => "Falmouth District Court",
    "CT_098" => "Eastern Hampshire District Court"
  }
end
