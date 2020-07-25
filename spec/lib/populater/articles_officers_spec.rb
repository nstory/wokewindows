describe Populater::ArticlesOfficers do
  let(:date_published) { nil }
  let(:body) { "foo bar\n\nCaptain James T Kirk\n\n" }
  let!(:article) do
    Article.create!(
      title: "foo",
      url: "http://example.com/foo/bar",
      body: body,
      date_published: date_published
    )
  end

  let(:hr_name) { "Kirk,James T" }
  let!(:officer) do
    Officer.create!(
      employee_id: 42,
      hr_name: hr_name,
      doa: "2015-06-29"
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

  describe "article from 2015-02-01" do
    let(:date_published) { "2015-02-01" }
    it "doesn't populate if officer start date after article date" do
      Populater::ArticlesOfficers.populate
      expect(ArticlesOfficer.count).to eql(0)
    end

    it "does populate if officer start date before article date" do
      officer.doa = "2015-01-14"
      officer.save
      Populater::ArticlesOfficers.populate
      expect(ArticlesOfficer.count).to eql(1)
    end

    it "does not populate officer with nil doa" do
      officer.doa = nil
      officer.save
      Populater::ArticlesOfficers.populate
      expect(ArticlesOfficer.count).to eql(0)
    end

    it "does populate officer with nil doa and 2014 earnings" do
      officer.doa = nil
      officer.save
      officer.compensations << Compensation.new(year: 2014)
      Populater::ArticlesOfficers.populate
      expect(ArticlesOfficer.count).to eql(1)
    end
  end

  describe "article from 2015-12-16" do
    let(:date_published) { "2015-12-16" }

    it "does populate officer with nil doa" do
      officer.doa = nil
      officer.save
      Populater::ArticlesOfficers.populate
      expect(ArticlesOfficer.count).to eql(1)
    end
  end

  describe "second officer with same name" do
    let!(:officer2) { o = officer.dup; o.employee_id += 1; o.save!; o }

    it "does not populate ambiguous officer" do
      Populater::ArticlesOfficers.populate
      expect(ArticlesOfficer.count).to eql(0)
    end
  end
end
