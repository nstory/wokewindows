describe "Incidents" do
  describe "index" do
    let(:offense) { Offense.new(code: 123, description: "chicanery") }
    let!(:incident) { Incident.create(incident_number: 123, street: "sesame", offenses: [offense]) }

    it "displays an incident" do
      visit incidents_path
      expect(page).to have_selector("td", text: "123")
      expect(page).to have_selector("td", text: "chicanery")
      expect(page).to have_selector("td", text: "sesame")
    end

    describe "searching" do
      before do
        visit incidents_path

        # make sure all incidents are being shown
        expect(page).to have_selector("td", text: "123")

        # make sure all incidents are filtered out
        fill_in "Search", with: "fleet"
        expect(page).to_not have_selector("td", text: "123")
        expect(page).to have_content("No matching records found")
      end

      it "searches street" do
        fill_in "Search", with: "sesame"
        expect(page).to have_selector("td", text: "123")
      end

      it "searches offense" do
        fill_in "Search", with: "chicanery"
        expect(page).to have_selector("td", text: "123")
      end
    end
  end
end
