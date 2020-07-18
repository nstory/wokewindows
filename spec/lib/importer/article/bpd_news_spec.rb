describe Importer::Article::BpdNews do
  include_context "tmpdir"

  let(:files) {{ "article.html" => file_fixture("bpd_news_article.html").read }}
  let(:importer) { Importer::Article::BpdNews.new(@tmpdir) }

  it "imports a file" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://bpdnews.com/news/2018/5/31/great-work-recognized-members-of-the-boston-police-department-and-dea-awarded-commissioners-commendations-for-outstanding-work")
    expect(a.title).to eql("Great Work Recognized: Members of the Boston Police Department and DEA Awarded Commissioner's Commendations for Outstanding Work")
    expect(a.body).to match(/^Today, May 31.*excellent work.$/m)
    expect(a.date_published).to eql("2018-05-31")
  end

  it "doesn't import a file twice" do
    importer.import
    importer.import
    expect(Article.count).to eql(1)
  end
end
