# https://www.courtlistener.com/api/rest-info/
class CourtListener
  def initialize(base_url = "https://www.courtlistener.com/api/rest/v3/", token = Rails.configuration.court_listener_token)
    @base_url = base_url
    @token = token
    raise "COURT_LISTENER_TOKEN must be set!" if !@token
  end

  def opinion(id)
    uri = URI("#{@base_url}opinions/#{id}/")
    OpinionResponse.new(get(uri))
  end

  def search(query)
    uri = URI("#{@base_url}search/")
    uri.query = query
    SearchResponse.new(get(uri), self)
  end

  def get(uri)
    Rails.logger.debug("get #{uri.to_s}")
    response = Faraday.get(uri, nil, {"Authorization" => "Token #{@token}"})
    JSON.parse(response.body)
  end

  class OpinionResponse
    attr_reader :id, :plain_text, :html_with_citations

    def initialize(json)
      @id = json["id"]
      @plain_text = json["plain_text"]
      @html_with_citations = json["html_with_citations"]
    end
  end

  class SearchResponse
    attr_reader :count, :next, :results

    def initialize(json, court_listener)
      @count = json["count"]
      @next = json["next"]
      @results = json["results"].map { |r| SearchResult.new(r) }
      @court_listener = court_listener
    end

    def get_next
      return nil if !@next
      SearchResponse.new(@court_listener.get(URI(@next)), @court_listener)
    end
  end

  class SearchResult
    attr_reader :id, :case_name, :date_filed, :absolute_url

    def initialize(json)
      @id = json["id"]
      @case_name = json["caseName"]
      @date_filed = json["dateFiled"]
      @absolute_url = json["absolute_url"]
    end
  end
end
