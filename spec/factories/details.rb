FactoryBot.define do
  factory :detail do
    factory :detail_kirk do
      tracking_no { 6502 }
      employee_number { 1701 }
      employee_name { "Jim Kirk" }
      employee_rank { 3 }
      customer_number { 42 }
      customer_name { "Utopia Planitia" }
      street_no { 23 }
      street { "Elm" }
      xstreet { "Main" }
      start_date_time { "2019-07-01 08:30:00" }
      end_date_time { "2019-07-01 14:30:00" }
      minutes_worked { 360 }
      detail_type { "C" }
      pay_hours { 8 }
      pay_amount { 368 }
      pay_rate { 46 }
      latitude { 42.23 }
      longitude { 23.42 }
      officer factory: :officer_kirk
    end
  end
end
