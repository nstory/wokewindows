describe Importer::CourtListener do
  let(:api) { instance_double(CourtListener) }
  let(:importer) { Importer::CourtListener.new(api) }
  let(:result) { instance_double(CourtListener::SearchResult, id: 123, case_name: "Foo v. Bar", date_filed: "2002-12-02T07:53:00Z", absolute_url: "/foo/bar") }
  let(:results) { [result] }
  let(:response) { instance_double(CourtListener::SearchResponse, results: results, get_next: next_response) }
  let(:next_response) { instance_double(CourtListener::SearchResponse, results: [], get_next: nil) }
  let(:opinion_response) { instance_double(CourtListener::OpinionResponse, html_with_citations: "<p>rofl</p>") }

  it "loads some opinions" do
    expect(api).to(
      receive(:search)
      .with("foo=bar")
      .and_return(response)
    )
    expect(api).to(
      receive(:opinion)
      .with(123)
      .and_return(opinion_response)
    )
    importer.import("foo=bar")
    a = Article.last
    expect(a.url).to eql("https://www.courtlistener.com/foo/bar")
    expect(a.title).to eql("Foo v. Bar")
    expect(a.body).to eql("rofl")
    expect(a.date_published).to eql("2002-12-02")
  end

  it "article already exists" do
    expect(api).to(
      receive(:search)
      .with("foo=bar")
      .and_return(response)
    )
    article = Article.create!(url: "https://www.courtlistener.com/foo/bar", title: "foo")
    importer.import("foo=bar")
    expect(Article.all.to_a).to eql([article])
  end
end
