namespace :articles do
  desc "downloads articles from bpdnews.com"
  task download: :environment do
    bn = BpdNews.new
    bn.articles.each do |article|
      item_id = article["data-item-id"]
      html = article.to_html
      IO.write("articles/#{item_id}.html", html)
    end
  end
end
