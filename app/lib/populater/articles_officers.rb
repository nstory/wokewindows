class Populater::ArticlesOfficers
  def self.populate
    regexp_to_officer = Officer.where("hr_name IS NOT NULL").map { |o| [officer_to_regexp(o), o] }.to_h
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

  private
  def self.officer_to_regexp(officer)
    last_name, first_name = officer.hr_name.split(",", 2)

    # middle initial is optional
    first_name.sub!(/ .*/) { |m| ".?" * m.length }

    Regexp.new("#{first_name}\\s+#{last_name}")
  end
end
