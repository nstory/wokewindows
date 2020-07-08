describe "Details" do
  let(:officer) { Officer.create(employee_id: 1234) }
  let!(:detail) { Detail.create(tracking_no: 42, street_no: 23, street: "sesame st", minutes_worked: 90, officer: officer, employee_name: "Xyzzy", employee_number: 4567) }

  describe "index" do
    describe "searching" do
      before do
        visit details_path

        # make sure all details are being shown
        expect(page).to have_selector("td", text: "42")

        # make sure all details are filtered out
        fill_in "Search", with: "asljdfk"
        expect(page).to_not have_selector("td", text: "42")
      end

      it "finds by tracking number" do
        fill_in "Search", with: "42"
        expect(page).to have_selector("td", text: "42")
      end

      it "finds by street address" do
        fill_in "Search", with: "23 sesame st"
        expect(page).to have_selector("td", text: "42")
      end
    end

    it "should display the detail" do
      visit details_path
      expect(page).to have_selector("td", text: "42")
      expect(page).to have_selector("td", text: "1:30")
      expect(page).to have_link("42", href: /details.*42/)
    end
  end

  describe "show" do
    it "should display details regarding the detail" do
      visit detail_path(detail)
      expect(page).to have_selector("dd", text: 42)
      expect(page).to have_link("Xyzzy", href: officer_path(officer))
      expect(page).to have_link("4567", href: officer_path(officer))
    end
  end
end
