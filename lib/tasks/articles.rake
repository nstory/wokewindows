namespace :articles do
  desc "downloads articles from bpdnews.com"
  task download: :environment do
    bn = BpdNews.new
    dup = 0
    bn.articles.each do |article|
      item_id = article["data-item-id"]
      filename = "articles/#{item_id}.html"
      html = article.to_html
      if File.exist?(filename)
        dup += 1
        exit if dup >= 5
      else
        IO.write(filename, html)
      end
    end
  end
end
