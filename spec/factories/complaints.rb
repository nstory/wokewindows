FactoryBot.define do
  factory :complaint do
    ia_number { "IAD2020-0042" }

    factory :complaint_kirk do
      ia_number { "IAD2260-0001" }
      case_number { 1234 }
      incident_type { "Internal investigation" }
      received_date { "2061-05-01" }
      occurred_date { "2061-04-20" }
      summary { "rofl xyzzy lol" }
    end
  end
end
