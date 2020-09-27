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
    res = []
    (article.body || "").scan(officer.article_regexp) do
      before = $`[[$`.length - size, 0].max .. -1]
      after = $'[0 ... size]
      res << [before, $&, after].join
    end
    res.uniq
  end

  def excerpt(size = 40)
    # first excerpt but de-prioritize excerpts with funny chars (sometimes
    # this is actually metadata about the article)
    excerpts(size).sort_by { |e| e.count("{}") }.first
  end

  def visible?
    added? || confirmed?
  end
end
