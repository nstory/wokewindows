class Importer::CourtListener
  MAX_PAGES = 100

  def self.import_all
    # "boston police" filed after 1/1/1990 by date filed desc
    new.import('q="boston%20police"&type=o&order_by=dateFiled%20desc&stat_Precedential=on&stat_Unknown%20Status=on&filed_after=01%2F01%2F1990')
  end

  def initialize(api = CourtListener.new)
    @api = api
  end

  def import(query)
    response = @api.search(query)
    MAX_PAGES.times do
      break if !response
      import_response(response)
      response = response.get_next
    end
  end

  def import_response(response)
    response.results.each do |result|
      import_result(result)
    end
  end

  def import_result(result)
    url = "https://www.courtlistener.com#{result.absolute_url}"
    return if Article.find_by(url: url) # skip if already exists
    opinion = @api.opinion(result.id)
    Article.create(
      url: url,
      title: result.case_name,
      body: ApplicationController.helpers.strip_tags(opinion.html_with_citations),
      date_published: parse_date_filed(result.date_filed)
    )
  end

  private
  def parse_date_filed(txt)
    txt.sub(/T.*/, "")
  end
end
