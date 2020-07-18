describe Importer::Article::BostonGlobe do
  include_context "tmpdir"

  let(:files) {{ "globe.html" => file_fixture("globe.html").read }}
  let(:importer) { Importer::Article::BostonGlobe.new(@tmpdir) }

  it "imports a file" do
    importer.import
    a = Article.first
    expect(a.url).to eql("https://www.bostonglobe.com/2013/07/12/boston-police-officer-arrested-charges-stealing-military-grade-explosives-arrested-plymouth-police/wXJ5qTJcOakjtdmtX2aLVN/story.html")
    expect(a.title).to eql("Boston Police officer arrested on charges of stealing military grade explosives; arrested by Plymouth police")
    expect(a.date_published).to eql("2013-07-12")
    expect(a.body).to match(/^PLYMOUTH.*problems\./m)
  end

  it "doesn't import twice" do
    importer.import
    importer.import
    expect(Article.count).to eql(1)
  end

  describe "file does not reference BPD" do
    let(:files) {{ "globe.html" => file_fixture("globe.html").read.gsub(/boston police/i, "xxx") }}
    it "does not import" do
      importer.import
      expect(Article.count).to eql(0)
    end
  end

  describe "file with <article> tag" do
    let(:files) {{ "globe.html" => file_fixture("globe2.html").read }}
    it "imports" do
      importer.import
      a = Article.first
      expect(a.url).to eql("https://www.bostonglobe.com/2020/02/03/metro/cops-preachers-make-good-teachers/")
      expect(a.title).to eql("Cops and preachers make good teachers")
      expect(a.date_published).to eql("2020-02-03")
      expect(a.body).to match(/Hennessey made a gaffe/i)
    end
  end
end
