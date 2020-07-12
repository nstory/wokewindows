describe "Citations" do
  let!(:citation) do
    Citation.create(
      ticket_number: "T123",
      location_name: "Roslindale",
      event_date: "2019-02-15 05:10:00",
      amount: 150,
      court_code: "CT_006"
    )
  end

  describe "index" do
    it "should display the citation" do
      visit citations_path
      expect(page).to have_selector("td", text: "T123")
      expect(page).to have_selector("td", text: "Roslindale")
      expect(page).to have_selector("td", text: "Feb 15, 2019 5:10 am")
      expect(page).to have_selector("td", text: "$150.00")
      expect(page).to have_selector("td", text: "West Roxbury BMC")
      expect(page).to have_link("T123", href: /citations.*T123/)
    end

    describe "searching" do
      before do
        visit citations_path

        # make sure all citations are being shown
        expect(page).to have_selector("td", text: "T123")

        # make sure all details are filtered out
        fill_in "Search", with: "asljdfk"
        expect(page).to_not have_selector("td", text: "T123")
      end

      it "finds by ticket number" do
        fill_in "Search", with: "T123"
        expect(page).to have_selector("td", text: "T123")
      end

      it "finds by court name" do
        fill_in "Search", with: "West Roxbury BMC"
        expect(page).to have_selector("td", text: "T123")
      end
    end
  end

  describe "show" do
    it "should display the citation" do
      visit citation_path(citation)
      expect(page).to have_selector("dd", text: "T123")
      expect(page).to have_selector("dd", text: "Roslindale")
      expect(page).to have_selector("dd", text: "Feb 15, 2019 5:10:00 AM")
      expect(page).to have_selector("dd", text: "$150.00")
      expect(page).to have_selector("dd", text: "West Roxbury BMC")
    end
  end
end
