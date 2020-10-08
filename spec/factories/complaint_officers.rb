FactoryBot.define do
  factory :complaint_officer do
    complaint
    officer

    factory :complaint_officer_kirk do
      name { "James T. Kirk" }
      title { "Cpt." }
      badge { 4242 }
      allegation { "Piracy" }
      finding { "Sustained" }
      finding_date { "2061-06-29" }
      action_taken { ["Flogging", "Feathering"] }
      complaint factory: :complaint_kirk
      officer factory: :officer_kirk
    end
  end
end
