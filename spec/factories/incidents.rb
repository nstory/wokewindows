FactoryBot.define do
  factory :incident do
    incident_number { 202000001 }

    factory :incident_kirk do
      officer factory: :officer_kirk
      incident_number { 192103868 }
      district { "B2" }
      reporting_area { 282 }
      shooting { false }
      occurred_on_date { "2019-12-26 17:00:00" }
      ucr_part { "Other" }
      street { "WASHINGTON ST" }
      latitude { 42.39 }
      longitude { -70.81 }
      report_date { "2019-12-26 18:33:04" }
      location_of_occurrence { ["10 JEROME ST"] }
      nature_of_incident { ["THREATS TO DO BODILY HARM"] }
      officer_journal_name { "106745  JOSE DIAZ" }
      geocode_latitude { 42.39 }
      geocode_longitude { -70.81 }
      reported_latitude { 34.56 }
      reported_longitude { 45.67 }
      location_type { "Highway/Road/Alley/Street/Sidewalk" }
      incident_clearance { "Victim Refused to Cooperate" }
      exceptional_clearance_date { "2019-12-28" }
      number_of_victims { 1 }
      number_of_offenders { 1 }
      number_of_arrestees { 0 }
      arrests_json { [] }
    end
  end
end
