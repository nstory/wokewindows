describe "Incidents" do
  let(:offense) { Offense.new(code: 123, description: "chicanery") }
  let!(:incident) { Incident.create(incident_number: 123, district: "D14", street: "sesame", offenses: [offense]) }

  describe "index" do
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

      it "normalizes incident number" do
        fill_in "Search", with: "I123-00"
        expect(page).to have_selector("td", text: "123")
      end

      it "searches district name" do
        fill_in "Search", with: "Brighton"
        expect(page).to have_selector("td", text: "123")
      end
    end
  end

  describe "show" do
    before { driven_by(:rack_test) }
    describe "incident with related case" do
      let!(:caze) { Case.create!(case_number: "123ABC", cases_incidents: [CasesIncident.new(incident: incident)]) }
      it "links to related case" do
        visit incident_path(incident)
        expect(page).to have_link("123ABC", href: case_path(caze))
      end
    end
  end
end
