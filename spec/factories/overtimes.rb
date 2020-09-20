FactoryBot.define do
  factory :overtime do
    factory :overtime_kirk do
      employee_id { 1701 }
      name { "Kirk,James" }
      rank { "SgtDet" }
      assigned { "A-1 DCU SQUAD" }
      charged { "A-1 DCU SQUAD" }
      date { "2014-01-02" }
      code { 280 }
      description { "COURT:TRIAL" }
      start_time { "0830" }
      end_time { "1030" }
      worked_hours { 2 }
      ot_hours { 4 }
      officer factory: :officer_kirk
    end
  end
end
