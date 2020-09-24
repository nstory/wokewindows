class ArticlesOfficer < ApplicationRecord
  enum status: {
    added: "added",
    rejected: "rejected",
    confirmed: "confirmed"
  }

  belongs_to :article
  belongs_to :officer

  counter_culture :officer, column_name: proc { |ao| ao.visible? ? 'articles_officers_count' : nil }, column_names: {["status in ('added', 'confirmed')"] => 'articles_officers_count'}

  def excerpts(size = 40)
    (article.body || "").scan(officer.article_regexp).map do
      [$`[-size .. -1], $&, $'[0 ... size]].join
    end.uniq
  end

  def excerpt(size = 40)
    excerpts(size).first
  end

  def visible?
    added? || confirmed?
  end
end
