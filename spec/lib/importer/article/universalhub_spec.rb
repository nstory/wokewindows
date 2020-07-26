describe Importer::Article::Universalhub do
  include_context "tmpdir"

  let(:content) { file_fixture("universalhub.html").read }
  let(:files) {{ "foo.html" => content }}
  let(:importer) { Importer::Article::Universalhub.new(@tmpdir) }

  it "imports an article" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://www.universalhub.com/2012/another-duty-cop-crashes-vehicle-hyde-park")
    expect(a.title).to eql("Another off-duty cop crashes in Hyde Park, this time into police warehouse")
    expect(a.date_published).to eql("2012-12-13")
    expect(a.body).to match(/off-duty Boston Police/)
  end
end
