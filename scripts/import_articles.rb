JSONL_FILE = ARGV.fetch(0)

IO.read(JSONL_FILE)
  .each_line
  .map(&:strip)
  .reject(&:blank?)
  .map { |line| JSON.parse(line) }
  .each do |props|
    officers = Officer.where(employee_id: props["articles_officer_ids"]).to_a
    article = Article.find_by(url: props['url']) || Article.new
    article.attributes = {
      url: props['url'],
      title: props['title'],
      body: props['body'],
      date_published: props['date_published'],
      officers: officers,
    }
    article.save
  end
