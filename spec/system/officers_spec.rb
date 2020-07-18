describe "Officers" do
  describe "show" do
    let!(:officer) { Officer.create!({employee_id: 1234, hr_name: "Foo,Bar"}) }

    it "displays an officer" do
      visit officer_path(officer)
      expect(page).to have_text("Foo, Bar")
      expect(page).to have_text("Boston Police Department")
      expect(page).to have_title("Foo, Bar")
    end

    describe "officer with an article" do
      let!(:article) { Article.create!(url: "http://example.com/foo", title: "LOL456") }
      let!(:articles_officer) { ArticlesOfficer.create!(article: article, officer: officer) }

      it "displays the article" do
        visit officer_path(officer)
        expect(page).to have_selector("td", text: "LOL456")
      end

      it "does not display a rejected article" do
        articles_officer.status = "rejected"
        articles_officer.save
        visit officer_path(officer)
        expect(page).to_not have_selector("td", text: "LOL456")
      end
    end
  end

  describe "index" do
    let!(:officer) { Officer.create(employee_id: 42, hr_name: "Kirk,James T", zip_code: ZipCode.new(zip: 2228)) }
    describe "searching" do
      before do
        visit officers_path

        # make sure all officers are being shown
        expect(page).to have_selector("td", text: "42")

        # make sure all officers are filtered out
        fill_in "Search", with: "lolroflcopter"
        expect(page).to_not have_selector("td", text: "42")
        expect(page).to have_content("No matching records found")
      end

      it "searches name" do
        fill_in "Search", with: "Kirk"
        expect(page).to have_selector("td", text: "42")
      end

      it "searches neighborhood" do
        fill_in "Search", with: "East Boston"
        expect(page).to have_selector("td", text: "42")
        expect(page).to have_selector("td", text: "East Boston")
      end
    end
  end
end
