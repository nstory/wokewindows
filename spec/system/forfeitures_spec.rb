describe "Forfeitures" do
  let!(:incident) { Incident.create(incident_number: 42) }
  let!(:forfeiture) { Forfeiture.create(sucv: "123-ABC", amount: "42.23", date: "2012-11-20", motor_vehicle: "2004 Dodge Neon", forfeitures_incidents: [ForfeituresIncident.new({incident: incident, incident_number: "123"})]) }

  describe "index" do
    it "should display the forfeiture" do
      visit forfeitures_path
      expect(page).to have_selector("td", text: "123-ABC")
      expect(page).to have_selector("td", text: "$42.23")
      expect(page).to have_selector("td", text: "Nov 20, 2012")
      expect(page).to have_selector("td", text: "2004 Dodge Neon")
      expect(page).to have_link("123", href: /incidents\/42/)
    end
  end

  describe "show" do
    before { driven_by(:rack_test) }
    it "should display the forfeiture" do
      visit forfeiture_path(forfeiture)
      expect(page).to have_content("123-ABC")
      expect(page).to have_content("$42.23")
      expect(page).to have_content("Nov 20, 2012")
      expect(page).to have_content("2004 Dodge Neon")
      expect(page).to have_link("123", href: /incidents\/42/)
    end
  end
end
