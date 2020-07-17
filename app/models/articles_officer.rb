class ArticlesOfficer < ApplicationRecord
  enum status: {
    added: "added",
    rejected: "rejected"
  }

  belongs_to :article
  belongs_to :officer

  counter_culture :officer, column_name: proc { |ao| ao.added? ? 'articles_officers_count' : nil }
end
