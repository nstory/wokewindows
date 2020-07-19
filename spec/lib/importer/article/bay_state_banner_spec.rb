describe Importer::Article::BayStateBanner do
  include_context "tmpdir"

  let(:content) { file_fixture("banner.html").read }
  let(:files) {{ "foo.html" => content }}
  let(:importer) { Importer::Article::BayStateBanner.new(@tmpdir) }

  it "imports an article" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://npaper-wehaa.com/baystatebanner/2019/08/01/?article=3311469&output=html")
    expect(a.title).to eql("Tremont Crossing project to begin site preparation")
    expect(a.date_published).to eql("2019-08-01")
    expect(a.body).to match(/727 housing units/)
  end
end
