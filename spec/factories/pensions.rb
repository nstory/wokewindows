FactoryBot.define do
  factory :pension do
    name { "MyString" }
    amount { "1234.56" }
    retirement_date { "2020-06-29" }
    department { "MyString" }
    job_description { "MyString" }
  end
end
