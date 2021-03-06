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
      expect(page).not_to have_text("highest earner")
      expect(page).to_not have_content("Law Enforcement Automatic Discovery")
    end

    it "displays an officer" do
      visit officer_path(officer_kirk)
      expect(page).to have_text("James T Kirk")
      expect(page).to have_content("Starship Captain at Boston Police")
      expect(page).to have_selector("dd", text: "Starfleet")
      expect(page).to have_selector("dd", text: "Starship Captain")
      expect(page).to have_selector("dd", text: "Mar 22, 2233")
      expect(page).to have_selector("dd", text: "Roslindale, MA 02131")
      expect(page).to have_selector("dd", text: "4223")
      expect(page).to have_title("Kirk, James T")
      expect(page).to have_text("42nd highest earner in 2020")
      expect(page).to have_content("Law Enforcement Automatic Discovery")
      expect(page).to have_content("Jun 29, 2012")
      expect(page).to have_content("stole a Klingon Bird of Prey")
      assert_meta_description(/James T Kirk/)
      assert_meta_description(/Boston Police Department/)
      assert_canonical_link(officer_path(officer_kirk))
    end

    describe "officer with an article" do
      let!(:articles_officer_kirk) { create(:articles_officer_kirk, officer: officer_kirk) }
      let(:article_kirk) { articles_officer_kirk.article }

      it "displays the article" do
        visit officer_path(officer_kirk)
        expect(page).to have_selector("td", text: "bar")
      end

      it "displays concerning articles" do
        visit officer_path(officer_kirk)
        expect(page).to have_content("that contain concerning allegations")
      end

      it "doesn't display concerning articles" do
        articles_officer_kirk.concerning = false
        articles_officer_kirk.save
        visit officer_path(officer_kirk)
        expect(page).to have_no_content("that contain concerning allegations")
      end

      it "does not display a rejected article" do
        articles_officer_kirk.status = "rejected"
        articles_officer_kirk.save
        visit officer_path(officer_kirk)
        expect(page).to_not have_selector("td", text: "bar")
      end

      it "does display a confirmed article" do
        articles_officer_kirk.status = "confirmed"
        articles_officer_kirk.save!
        visit officer_path(officer_kirk)
        expect(page).to have_selector("td", text: "bar")
      end

      it "does not link to article edit page" do
        visit officer_path(officer_kirk)
        expect(page).to have_selector("td", text: "bar")
        expect(page).to have_no_link(href: Regexp.new(edit_article_path(article_kirk)))
      end

      it "does link to article edit page if user logged in" do
        visit officer_path(officer_kirk, as: user)
        expect(page).to have_link(href: Regexp.new(edit_article_path(article_kirk)))
      end

      it "does not display confirm all link for non-logged-in user" do
        visit officer_path(officer_kirk)
        # wait until page is loaded
        expect(page).to have_selector("td", text: "bar")
        expect(page).to have_no_link("Confirm All")
      end

      it "confirm all articles" do
        articles_officer_kirk.status = "added"
        articles_officer_kirk.save
        visit officer_path(officer_kirk, as: user)
        accept_confirm do
          click_link "Confirm All"
        end
        wait_for { articles_officer_kirk.reload.confirmed? }.to eql(true)
      end
    end

    describe "officer with a pension" do
      let!(:pension) { create(:pension, officer: officer_kirk) }
      it "displays pension amount and retirement date" do
        visit officer_path(officer_kirk)
        expect(page).to have_content("$1,234.56")
        expect(page).to have_content("Jun 29, 2020")
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

  xdescribe "field_contacts" do
    let!(:field_contact_name_kirk) { create(:field_contact_name_kirk) }

    it "displays stuff" do
      visit field_contacts_officer_path(Officer.last)
      expect(page).to have_selector("h1", text: "James T Kirk")
      expect(page).to have_selector(".stopped-black", text: "1")
    end
  end
end
