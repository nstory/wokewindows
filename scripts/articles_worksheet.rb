def output
  mapping = {
    "id" => ->(ao) { ao.id },
    "date" => ->(ao) { ao.article.date_published },
    "title" => ->(ao) { ao.article.title },
    "url" => ->(ao) { ao.article.url },
    "officer" => ->(ao) { ao.officer.name },
    "doa" => ->(ao) { ao.officer.doa },
    "officer_url" => ->(ao) { "https://www.wokewindows.org/officers/#{ao.officer.employee_id}" },
    "status" => ->(ao) { ao.status },
    "new_status" => ->(ao) { "" },
    "concerning" => ->(ao) { ao.concerning },
    "new_concerning" => ->(ao) { "" },
    "excerpts" => ->(ao) { ao.excerpts.join(" ... ").gsub(/\s+/, " ") },
  }

  puts mapping.keys.to_csv
  ArticlesOfficer.includes(:article, :officer).find_each do |ao|
    next if ao.status == "rejected"
    next if ["Pax Centurion", "bpdnews.com"].include?(ao.article.source)
    puts mapping.values.map { |l| l.call(ao) }.to_csv
  end
end

def input
  CSV.foreach(ARGV[1], headers: true, encoding: "ISO-8859-1") do |row|
    a = Article.find_by url: row['url']
    raise "whut" if !a
    ao = a.articles_officers.find { |aao| aao.officer.name == row['officer'] }
    raise "whut" if !ao

    # update status
    if ao.status == row['status'] && !(row['new_status'].blank?)
      Rails.logger.info "#{ao.id}: #{ao.status} -> #{row['new_status']}"
      ao.status = row['new_status']
      ao.save
    end

    # update concerning-ness
    if !row['new_concerning'].blank?
      Rails.logger.info "#{ao.id}: new_concerning = #{row['new_concerning']}"
      ao.concerning = true if /^t/i =~ row['new_concerning']
      ao.concerning = false if /^f/i =~ row['new_concerning']
      ao.save
    end
  end
end

send(ARGV[0].to_sym)
