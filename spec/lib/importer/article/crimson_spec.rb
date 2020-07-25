describe Importer::Article::Crimson do
  include_context "tmpdir"

  let(:content) { file_fixture("crimson.html").read }
  let(:files) {{ "foo.html" => content }}
  let(:importer) { Importer::Article::Crimson.new(@tmpdir) }

  it "imports an article" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://www.thecrimson.com/article/2020/2/24/democrats-on-mass-primary/")
    expect(a.title).to eql("Presidential Campaigns Gear Up for Massachusetts Primary on Mar. 3")
    expect(a.date_published).to eql("2020-02-24")
    expect(a.body).to match(/Warren campaign/)
  end
end
