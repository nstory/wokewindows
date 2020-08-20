describe "Officers" do
  let!(:user) { User.create!(email: "foo@wokewindows.org", password: "foo") }

  describe "show" do
    let!(:officer) { create(:officer) }
    let!(:officer_kirk) { create(:officer_kirk) }

    it "redirects to full officer_path when only an officer's employee_id is provided" do
      visit "/officers/#{officer.employee_id}"
      expect(page).to have_current_path(officer_path(officer))
    end

    it "displays minimal officer" do
      visit officer_path(officer)
      expect(page).to have_selector("dd", text: "14242")
      expect(page).not_to have_text("highest earner in 2019")
    end

    it "displays an officer" do
      visit officer_path(officer_kirk)
      expect(page).to have_text("Kirk, James T")
      expect(page).to have_selector("dd", text: "Boston Police Department")
      expect(page).to have_selector("dd", text: "Starfleet")
      expect(page).to have_selector("dd", text: "Starship Captain")
      expect(page).to have_selector("dd", text: "Mar 22, 2233")
      expect(page).to have_selector("dd", text: "02131 Roslindale, MA")
      expect(page).to have_selector("dd", text: "4223")
      expect(page).to have_title("Kirk, James T")
      expect(page).to have_text("42nd highest earner in 2019")
      assert_meta_description(/James T Kirk/)
      assert_meta_description(/Boston Police Department/)
      assert_canonical_link(officer_path(officer_kirk))
    end

    describe "officer with an article" do
      let!(:article) { Article.create!(url: "http://example.com/foo", title: "LOL456", body: "rofl James T Kirk lmao") }
      let!(:articles_officer) { ArticlesOfficer.create!(article: article, officer: officer_kirk) }

      it "displays the article" do
        visit officer_path(officer_kirk)
        expect(page).to have_selector("td", text: "LOL456")
      end

      it "does not display a rejected article" do
        articles_officer.status = "rejected"
        articles_officer.save
        visit officer_path(officer_kirk)
        expect(page).to_not have_selector("td", text: "LOL456")
      end

      it "does display a confirmed article" do
        articles_officer.status = "confirmed"
        articles_officer.save!
        visit officer_path(officer_kirk)
        expect(page).to have_selector("td", text: "LOL456")
      end

      it "does not link to article edit page" do
        visit officer_path(officer_kirk)
        expect(page).to have_selector("td", text: "LOL456")
        expect(page).to have_no_link(href: Regexp.new(edit_article_path(article)))
      end

      it "does link to article edit page if user logged in" do
        visit officer_path(officer_kirk, as: user)
        expect(page).to have_link(href: Regexp.new(edit_article_path(article)))
      end

      it "does not display confirm all link for non-logged-in user" do
        visit officer_path(officer_kirk)
        # wait until page is loaded
        expect(page).to have_selector("td", text: "LOL456")
        expect(page).to have_no_link("Confirm All")
      end

      it "confirm all articles" do
        visit officer_path(officer_kirk, as: user)
        accept_confirm do
          click_link "Confirm All"
        end
        wait_for { articles_officer.reload.confirmed? }.to eql(true)
      end
    end
  end

  describe "index" do
    let!(:officer) { create(:officer) }
    let!(:officer_kirk) { create(:officer_kirk) }

    describe "searching" do
      before do
        visit officers_path

        # make sure all officers are being shown
        expect(page).to have_selector("td", text: "1701")

        # make sure all officers are filtered out
        fill_in "Search", with: "lolroflcopter"
        expect(page).to_not have_selector("td", text: "1701")
        expect(page).to have_content("No matching records found")
      end

      it "searches name" do
        fill_in "Search", with: "Kirk"
        expect(page).to have_selector("td", text: "1701")
      end

      it "searches neighborhood" do
        fill_in "Search", with: "Roslindale"
        expect(page).to have_selector("td", text: "1701")
        expect(page).to have_selector("td", text: "Roslindale")
      end

      it "searches badge number" do
        fill_in "Search", with: "4223"
        expect(page).to have_selector("td", text: "1701")
      end

      it "searches organization" do
        fill_in "Search", with: "Starfleet"
        expect(page).to have_selector("td", text: "1701")
      end
    end

    it "displays fields" do
      visit officers_path
      expect(page).to have_selector("td", text: "014242")
      expect(page).to have_selector("td", text: "4223")
      expect(page).to have_selector("td", text: "Kirk, James T")
      expect(page).to have_selector("td", text: "Starship Captain")
      expect(page).to have_selector("td", text: "Starfleet")
      expect(page).to have_selector("td", text: "Mar 22, 2233")
      expect(page).to have_selector("td", text: "02131")
    end
  end
end
