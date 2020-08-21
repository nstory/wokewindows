describe CourtListener do
  let(:court_listener) { CourtListener.new("http://example.wokewindows.org/", "abc123") }
  let(:response) { OpenStruct.new(body: body) }

  before do
    expect(Faraday).to(
      receive(:get)
      .with(uri, nil, {"Authorization" => "Token abc123"})
      .and_return(response)
    )
  end

  describe "search" do
    let(:body) { file_fixture("court_listener_search.json").read }
    let(:uri) { URI("http://example.wokewindows.org/search/?foo=bar") }

    it "parses the response" do
      response = court_listener.search("foo=bar")
      expect(response.count).to eql(1179)
      expect(response.next).to match(/^https.*type=o$/)
      result = response.results.first
      expect(result.id).to eql(200231)
      expect(result.case_name).to eql("Gu v. Boston Police Dept.")
      expect(result.date_filed).to eql("2002-12-02T07:53:00Z")
      expect(result.absolute_url).to eql("/opinion/200231/gu-v-boston-police-dept/")
    end
  end

  describe "opinion" do
    let(:body) { file_fixture("court_listener_opinion.json").read }
    let(:uri) { URI("http://example.wokewindows.org/opinions/123/") }

    it "parses the response" do
      response = court_listener.opinion(123)
      expect(response.id).to eql(200231)
      expect(response.plain_text).to match(/OFFICE OF RESEARCH/)
      expect(response.html_with_citations).to match(/Deputy Director of the Office of Research/)
    end
  end
end
