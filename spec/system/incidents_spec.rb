describe "Incidents", type: :system do
  describe "index" do
    let(:offense) { Offense.new(code: 123, description: "chicanery") }
    let!(:incident) { Incident.create(incident_number: 123, offenses: [offense]) }

    it "displays an incident" do
      visit incidents_path
      expect(page).to have_selector("td", text: "123")
      expect(page).to have_selector("td", text: "chicanery")
    end
  end
end
