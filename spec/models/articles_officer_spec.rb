describe ArticlesOfficer do
  let!(:articles_officer_kirk) { create(:articles_officer_kirk) }
  let(:article_kirk) { articles_officer_kirk.article }
  describe "#excerpt" do
    it "prefers excerpt without funny chars" do
      article_kirk.body = "{name: \"Captain James Kirk\" foo" + " "*90 + "James Kirk is silly"
      article_kirk.save
      expect(articles_officer_kirk.excerpt).to match(/is silly/)
    end
  end

  describe "#excerpts" do
    it "matches all instances of name" do
      article_kirk.body = "hello James Kirk " + " "*90 + "bye James Kirk man"
      article_kirk.save
      expect(articles_officer_kirk.excerpts.count).to eql(2)
    end
  end
end
