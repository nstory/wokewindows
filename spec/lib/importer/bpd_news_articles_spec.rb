describe Importer::BpdNewsArticles do
  let(:file) { file_fixture("bpd_news_articles") }
  let(:importer) { Importer::BpdNewsArticles.new(file) }

  it "imports a file" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://bpdnews.com/news/2018/5/31/great-work-recognized-members-of-the-boston-police-department-and-dea-awarded-commissioners-commendations-for-outstanding-work")
    expect(a.title).to eql("Great Work Recognized: Members of the Boston Police Department and DEA Awarded Commissioner's Commendations for Outstanding Work")
    expect(a.body).to match(/^Today, May 31.*excellent work.$/m)
  end

  it "doesn't import a file twice" do
    importer.import
    importer.import
    expect(Article.count).to eql(1)
  end
end
