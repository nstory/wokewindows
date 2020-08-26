FactoryBot.define do
  factory :officer do
    employee_id { 14242 }

    factory :officer_kirk do
      employee_id { 1701 }
      hr_name { "Kirk,James T" }
      doa { "2233-03-22" }
      zip_code
      earnings_rank { 42 }
      organization { "Starfleet" }
      title { "Starship Captain" }
      rank { "capt" }
      badge { "4223" }
      regular { 142061.86 }
      retro { 0.0 }
      other { 21262.85 }
      overtime { 115361.12 }
      injured { 0.0 }
      detail { 41360.0 }
      quinn { 35492.87 }
      total { 355538.7 }
      ia_score { 4 }
      field_contacts_count { 13 }
      incidents_count { 14 }
      complaints_count { 15 }
      swats_count { 16 }
      details_count { 17 }
      citations_count { 18 }
      articles_officers_count { 19 }
    end
  end
end
