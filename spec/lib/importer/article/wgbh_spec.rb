describe Importer::Article::Wgbh do
  include_context "tmpdir"

  let(:content) { file_fixture("wgbh.html").read }
  let(:files) {{ "foo.html" => content }}
  let(:importer) { Importer::Article::Wgbh.new(@tmpdir) }

  it "imports an article" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://www.wgbh.org/news/local-news/2018/12/21/the-case-against-sean-ellis-collapses-amidst-evidence-of-police-corruption")
    expect(a.title).to eql("The Case Against Sean Ellis Collapses Amidst Evidence Of Police Corruption")
    expect(a.date_published).to eql("2018-12-21")
    expect(a.body).to match(/electronic bracelet he had worn/)
  end
end
