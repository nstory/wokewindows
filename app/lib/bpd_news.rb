require "open-uri"

# crawler to download pdf files from https://bpdnews.com/
class BpdNews
  def initialize(output_directory, start_url = "https://bpdnews.com")
    @output_directory = output_directory
    @start_url = start_url
  end

  def crawl
    url = @start_url
    while url do
      links = get_links(url)
      download_pdfs(links)
      url = next_url(links)
    end
  end

  private
  def download_pdfs(links)
    links.select { |l| l =~ /\.pdf$/ }.each do |pdf_link|
      pdf = get_file(pdf_link)
      filename = URI(pdf_link).path.sub(%r(^.*/), "")
      IO.write("#{@output_directory}/#{filename}", pdf, mode: "wb")
    end
  end

  def get_file(url)
    Rails.logger.info "get_file #{url}"
    s = nil
    retry_it do
      open(url, "rb") do |io|
        s = io.read
      end
    end
    s
  end

  def get_links(url)
    Rails.logger.info "get_links #{url}"
    page = nil
    retry_it { page = get_page(url) }
    Rails.logger.info "response.status = #{page.response.status}"
    page.links.all.map do |l|
      URI.join("https://bpdnews.com", l).to_s
    end
  end

  def get_page(url)
    page = MetaInspector.new(url, download_images: false)
    raise "bad status" if page.response.status != 200
    page
  end

  def retry_it
    retries = 10
    begin
      yield
    rescue
      if retries > 0
        retries -= 1
        sleep 2
        retry
      else
        raise "retries exhausted"
      end
    end
  end

  def next_url(links)
    links.find { |l| l =~ /offset=\d+$/ }
  end
end
