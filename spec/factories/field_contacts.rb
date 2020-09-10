FactoryBot.define do
  factory :field_contact do
    fc_num { "FC123" }

    factory :field_contact_kirk do
      contact_officer factory: :officer_kirk
      fc_num { "FC234" }
      contact_date { "2019-12-23 01:00:00" }
      contact_officer_employee_id { 148317 }
      contact_officer_name { "jimmy kirk" }
      supervisor_employee_id { 103734 }
      supervisor_name { "admiral xyzzy" }
      street { "huntington ave" }
      city { "boston" }
      state { "ma" }
      zip { 2116 }
      frisked_searched { false }
      circumstance { "encountered" }
      basis { "probable_cause" }
      vehicle_year { 2013 }
      vehicle_state { "ma" }
      vehicle_make { "kia motors corp" }
      vehicle_model { "optima" }
      vehicle_color { "gray" }
      vehicle_style { "passenger car" }
      vehicle_type { "sedan" }
      key_situations { ["body worn camera"] }
      narrative {  "rofl lol" }
      weather { "sunny" }
      field_contact_names_count { 23 }
      stop_duration { "fifteen_to_twenty_minutes" }
      search_vehicle { true }
      summons_issued { true }
    end
  end
end
