class Populater::ArticlesOfficers
  def self.populate
    regexp_to_officer = Officer.where("hr_name IS NOT NULL").map { |o| [o.article_regexp, o] }.to_h
    Article.find_each do |article|
      regexp_to_officer.each do |regexp,officer|
        next if article_precedes_officer?(article, officer)
        if regexp =~ article.body
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

    # officers hired after 12/14/2015 don't have start date data, so
    # assume the earliest possible date
    start_date = officer.doa || "2015-12-15"

    return article.date_published < start_date
  end
end
