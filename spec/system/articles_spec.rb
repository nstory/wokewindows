describe "Articles" do
  let!(:officer) { Officer.create! employee_id: 42, hr_name: "Foo,Bar" }
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

    describe "article officers" do
      before { driven_by :selenium_chrome_headless }

      it "adds officer" do
        visit edit_article_path(article, as: user)

        # wait for select2 to initialize
        expect(page).to have_selector(".select2", visible: false)

        # clicking the select isn't working :shrug:
        execute_script('$("select").select2("open")')

        # select the first and only option
        page.find(".select2-results__option").click
        click_button "Add"

        # confirm the new connection is displayed and saved
        expect(page).to have_content("Foo, Bar")
        ao = ArticlesOfficer.first
        expect(ao.officer).to eql(officer)
        expect(ao.article).to eql(article)
        expect(ao.confirmed).to eql(true)
        expect(ao.status).to eql("added")

        # un-confirm the officer
        page.uncheck("articles_officer[confirmed]")
        wait_for { ao.reload.confirmed }.to eql(false)

        # now delete the officer
        click_link "Remove"
        expect(page).to have_no_content("Foo, Bar")
      end
    end
  end
end
