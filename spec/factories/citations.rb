FactoryBot.define do
  factory :citation do
    ticket_number { "T42" }
    offenses {[CitationOffense.new]}

    factory :citation_kirk do
      officer factory: :officer_kirk
      ticket_number { "T23" }
      issuing_agency { "Boston Police District B-3" }
      officer_number { 148287 }
      ticket_type { "CRIM" }
      source { "COURT" }
      violator_type { "OPERATOR" }
      cdl { false }
      license_class { "AM" }
      event_date { "2019-01-01 10:15:00" }
      location_id { 904 }
      location_name { "Dorchester" }
      posted_speed { 42 }
      violation_speed { 64 }
      posted { true }
      radar { true }
      clocked { true }
      race { "BLACK" }
      sex { "MALE" }
      vehicle_color { "GRAY" }
      make { "JEEP GRAND" }
      model_year { 2008 }
      sixteen_pass { false }
      haz_mat { false }
      amount { 0.0 }
      paid { true }
      hearing_requested { false }
      court_code { "CT_007" }
      age { 52 }
      searched { false }
      offenses {[
        CitationOffense.new({
          "offense"=>"9010A2",
          "description"=>"UNLICENSED OPERATION OF MV c90 10",
          "assessment"=> 1,
          "expected_assessment"=> 2,
          "display_assessment"=> 3,
          "disposition"=>"NPC",
          "disposition_description"=>"No Probable Cause Found",
          "major_incident"=>false,
          "surchargeable"=>true,
          "sdip_points"=>2
        })
      ]}
    end
  end
end
