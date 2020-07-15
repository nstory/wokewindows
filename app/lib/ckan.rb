# minimal client for CKAN, the open data portal used by data.boston.gov
# https://docs.ckan.org/en/latest/api/index.html
class Ckan
  def initialize(site = "https://data.boston.gov/")
    @site = site
  end

  def package_show(id)
    uri = URI.join(@site, "/api/3/action/package_show")
    uri.query = URI.encode_www_form("id" => id)
    response = Net::HTTP.get(uri)
    Response.new(JSON.parse(response))
  end

  class Response
    def initialize(json)
      @json = json
    end

    def resources
      @json.dig("result", "resources").map { |r| Resource.new(r) }
    end
  end

  class Resource
    def initialize(json)
      @json = json
    end

    def url
      @json["url"]
    end

    def last_modified
      @json["last_modified"]
    end

    def name
      name = @json["name"]
      name = @json.dig("name_translated", "en") if name.blank?
      name
    end
  end
end
