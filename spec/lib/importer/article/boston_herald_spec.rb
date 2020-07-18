describe Importer::Article::BostonHerald do
  include_context "tmpdir"

  let(:content) { file_fixture("herald.html").read }
  let(:files) {{ "foo.html" => content }}
  let(:importer) { Importer::Article::BostonHerald.new(@tmpdir) }

  it "imports an article" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://www.bostonherald.com/2019/05/06/boston-cop-fired-after-strippers-accused-of-stealing-his-gun/")
    expect(a.title).to eql("Boston cop fired after strippers accused of stealing his gun")
    expect(a.date_published).to eql("2019-05-06")
    expect(a.body).to match(/gun allegedly stolen/)
  end
end
