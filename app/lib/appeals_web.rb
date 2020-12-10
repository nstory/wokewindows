# https://www.sec.state.ma.us/AppealsWeb/AppealsStatus.aspx
class AppealsWeb
  def home
    doc = get_html("https://www.sec.state.ma.us/AppealsWeb/AppealsStatus.aspx")
  end

  private
  def get_html(url)
    conn = Faraday.new(:url => url) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects
    end
    resp = conn.get do |req|
      req.headers['User-Agent'] = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    end
    Nokogiri::HTML(resp.body)
  end
end
