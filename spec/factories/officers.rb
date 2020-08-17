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
      badge { "4223" }
    end
  end
end
