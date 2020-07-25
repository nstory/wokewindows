describe "Articles" do
  let!(:user) { User.create!(email: "foo@wokewindows.org", password: "foo") }
  let(:article) { Article.new(url: "http://example.com", title: "foo") }

  before do
    allow_any_instance_of(ArticleFetcher)
      .to receive(:fetch).and_return(article)
  end

  before { driven_by(:rack_test) }

  describe "new" do
    it "saves the article" do
      visit new_article_path(as: user)
      fill_in "URL", with: "rofl"
      click_button "Submit"
      expect(Article.last).to eql(article)
    end

    describe "ArticleFetcher returns nil" do
      let(:article) { nil }
      it "shows form again with error message" do
        visit new_article_path(as: user)
        fill_in "URL", with: "rofl"
        click_button "Submit"
        expect(page).to have_field("URL", with: "rofl")
        expect(page).to have_content("Error fetching URL")
      end
    end

    describe "existing article with same url" do
      let!(:existing) { Article.create!(url: "http://example.com", title: "foo") }
      it "redirects to existing article" do
        visit new_article_path(as: user)
        fill_in "URL", with: "rofl"
        click_button "Submit"
        expect(current_path).to eql(edit_article_path(existing))
        expect(page).to have_content("existing article")
      end
    end
  end

  describe "edit" do
    let!(:article) { Article.create!(url: "http://example.com", title: "Foo bar", date_published: "2020-01-02") }

    it "persists changes" do
      visit edit_article_path(article, as: user)
      fill_in "article_url", with: "http://foobar.com"
      fill_in "article_title", with: "LOL"
      fill_in "article_date_published", with: "2019-05-01"
      click_button "Save"
      article.reload
      expect(article.url).to eql("http://foobar.com")
      expect(article.title).to eql("LOL")
      expect(article.date_published).to eql("2019-05-01")
    end

    it "validates" do
      visit edit_article_path(article, as: user)
      fill_in "article_url", with: ""
      click_button "Save"
      expect(page).to have_content("can't be blank")
    end
  end
end
