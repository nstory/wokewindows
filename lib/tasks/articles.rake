namespace :articles do
  desc "downloads articles from bpdnews.com"
  task download: :environment do
    directory = "data/bpd_news_articles"
    `mkdir -p #{directory}`
    s3_prefix = "bpd_news_articles"

    s3 = S3.new("us-east-1", "wokewindows-data")
    bn = BpdNews.new

    dup = 0
    bn.articles.each do |article|
      item_id = article["data-item-id"]
      filename = "#{directory}/#{item_id}.html"
      s3_key = "#{s3_prefix}/#{item_id}.html"
      html = article.to_html

      if s3.object_exists?(s3_key)
        dup += 1
        break if dup >= 5
      else
        Rails.logger.info("write #{filename}")
        IO.write(filename, html)
        s3.upload_object(s3_key, StringIO.new(html))
      end
    end
  end
end
