describe Importer::Article::Wbur do
  include_context "tmpdir"

  let(:content) { file_fixture("wbur.html").read }
  let(:files) {{ "foo.html" => content }}
  let(:importer) { Importer::Article::Wbur.new(@tmpdir) }

  it "imports an article" do
    importer.import
    a = Article.first
    expect(a.url).to eql("http://www.wbur.org/2016/03/21/fatal-shooting-roxbury")
    expect(a.title).to eql("Boston Police Investigate Fatal Shooting In Roxbury")
    expect(a.date_published).to eql("2016-03-21")
    expect(a.body).to match(/person shot in the area/)
  end
end
