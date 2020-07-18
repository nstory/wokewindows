class Populater::ArticlesOfficers
  def self.populate
    regexp_to_officer = Officer.where("hr_name IS NOT NULL").map { |o| [o.article_regexp, o] }.to_h
    Article.find_each do |article|
      regexp_to_officer.each do |regexp,officer|
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
end
