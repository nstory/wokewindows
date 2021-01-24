describe ArticleFetcher do
  let(:code) { 200 }
  let(:body) { "" }
  let(:headers) { OpenStruct.new(content_type: "text/html") }
  let(:response) { OpenStruct.new(body: body, code: code, headers: headers) }
  let(:article_fetcher) { ArticleFetcher.new("http://wokewindows.org/foobar") }
  let(:article) { article_fetcher.fetch }

  describe "response" do
    before do
      expect(HTTParty).to receive(:get).and_return(response)
    end

    describe "globe article" do
      let(:body) { file_fixture("globe.html").read }
      let!(:officer) { Officer.create!(hr_name: "Merricks, Kirk D.", employee_id: 42) }

      it "returns article" do
        a = article_fetcher.fetch
        expect(a.title).to match(/stealing military grade explosives/)
        expect(a.url).to eql("https://www.bostonglobe.com/2013/07/12/boston-police-officer-arrested-charges-stealing-military-grade-explosives-arrested-plymouth-police/wXJ5qTJcOakjtdmtX2aLVN/story.html")
        expect(a.date_published).to eql("2013-07-12")
        expect(a.body).to match(/four counts of receiving/)
        expect(a.officers.to_a).to eql([officer])
      end
    end

    describe "herald article" do
      let(:body) { file_fixture("herald.html").read }

      it "returns article" do
        a = article_fetcher.fetch
        expect(a.title).to match(/Boston cop fired/)
        expect(a.url).to eql("https://www.bostonherald.com/2019/05/06/boston-cop-fired-after-strippers-accused-of-stealing-his-gun/")
        expect(a.date_published).to eql("2019-05-06")
      end
    end

    describe "patriot ledger" do
      let(:body) { file_fixture("patriotledger.html").read }
      it "returns article" do
        a = article_fetcher.fetch
        expect(a.title).to match(/Boston police detective/)
      end
    end

    describe "pdf document" do
      let(:body) { file_fixture("district_journal.pdf") }
      let(:headers) { OpenStruct.new(content_type: "application/pdf") }
      it "returns article" do
        expect(article.url).to eql("http://wokewindows.org/foobar")
        expect(article.title).to eql("foobar")
        expect(article.date_published).to eql(nil)
        expect(article.body).to eql("")
      end
    end

    describe "404 status code" do
      let(:code) { 404 }

      it "returns nil" do
        expect(article_fetcher.fetch).to eql(nil)
      end
    end
  end

  describe "exception thrown by http request" do
    before do
      expect(HTTParty).to receive(:get).and_raise(Errno::ECONNREFUSED)
    end

    it "returns nil" do
      expect(article_fetcher.fetch).to eql(nil)
    end
  end
end
