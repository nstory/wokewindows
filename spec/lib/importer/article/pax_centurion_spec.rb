describe Importer::Article::PaxCenturion do
  include_context "tmpdir"

  let(:content) { file_fixture("pax_centurion_2019_spring_21.txt").read }
  let(:files) {{ "pax_centurion_2019_spring_21.txt" => content }}
  let(:importer) { Importer::Article::PaxCenturion.new(@tmpdir) }

  it "imports the article" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://wokewindows-data.s3.amazonaws.com/pax_centurion_issues/pax_centurion_2019_spring.pdf#page=21")
    expect(a.title).to eql("Pax Centurion 2019 Spring - Page 21")
    expect(a.body).to match(/very sad note/)
    expect(a.date_published).to eql("2019-01-01")
  end
end
