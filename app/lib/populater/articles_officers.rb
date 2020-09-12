class Populater::ArticlesOfficers
  def self.populate
    matcher = OfficerMatcher.new
    Article.find_each do |article|
      matches = matcher.matches(article.body || "")
      matches.each do |officer|
        if !article_precedes_officer?(article, officer)
          ArticlesOfficer.create(
            officer: officer,
            article: article,
            status: :added
          )
        end
      rescue ActiveRecord::RecordNotUnique
        # ignore
      end
    end
  end

  private

  # whether article was published before the officer started at BPD
  def self.article_precedes_officer?(article, officer)
    return false if article.date_published.blank?

    start_date = officer.doa

    if !start_date
      if officer.compensations.any? { |c| c.year <= 2014 }
        # officer left in 2015 or before
        start_date = "1980-01-01"
      else
        # officer hired after 2015
        start_date = "2015-12-15"
      end
    end

    return article.date_published < start_date
  end
end
