FactoryBot.define do
  factory :article do
    url { "http://www.example.com/foo" }
    title { "foo" }

    factory :article_kirk do
      url { "http://www.example.com/bar" }
      title { "bar" }
      body { "xyzzy" }
      date_published { "2020-06-29" }
    end
  end
end
