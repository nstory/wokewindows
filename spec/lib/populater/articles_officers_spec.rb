describe Populater::ArticlesOfficers do
  let(:body) { "foo bar\n\nCaptain James T Kirk\n\n" }
  let!(:article) do
    Article.create!(
      url: "http://example.com/foo/bar",
      body: body
    )
  end

  let(:hr_name) { "Kirk,James T" }
  let!(:officer) do
    Officer.create!(
      employee_id: 42,
      hr_name: hr_name
    )
  end

  it "populates" do
    Populater::ArticlesOfficers.populate
    ao = ArticlesOfficer.first
    expect(ao.article).to eql(article)
    expect(ao.officer).to eql(officer)
    expect(ao.status).to eql("added")
  end

  it "doesn't populate twice" do
    Populater::ArticlesOfficers.populate
    Populater::ArticlesOfficers.populate
    expect(ArticlesOfficer.count).to eql(1)
  end

  describe "body without middle initial" do
    let(:body) { "foo bar\n\nCaptain James Kirk\n\n"  }
    it "populates" do
      Populater::ArticlesOfficers.populate
      expect(ArticlesOfficer.first.officer).to eql(officer)
    end
  end
end
