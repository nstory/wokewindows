FactoryBot.define do
  factory :articles_officer do
    article factory: :article
    officer factory: :officer

    factory :articles_officer_kirk do
      status { "confirmed" }
      concerning { true }
      article factory: :article_kirk
      officer factory: :officer_kirk
    end
  end
end
