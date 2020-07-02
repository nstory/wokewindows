describe "Cases" do
  let!(:incident) { Incident.create(incident_number: 42) }
  let!(:caze) { Case.create(case_number: "1284CV00125", court: "superior", amount: "42.23", date: "2012-11-20", motor_vehicle: "2004 Dodge Neon", cases_incidents: [CasesIncident.new({incident: incident, incident_number: "123"})]) }

  describe "index" do
    it "should display the case" do
      visit cases_path
      expect(page).to have_selector("td", text: "1284CV00125")
      expect(page).to have_selector("td", text: "Superior Court")
      expect(page).to have_selector("td", text: "$42.23")
      expect(page).to have_selector("td", text: "Nov 20, 2012")
      expect(page).to have_selector("td", text: "2004 Dodge Neon")
      expect(page).to have_link("123", href: /incidents\/42/)
      expect(page).to have_link("1284CV00125", href: /cases.*1284CV00125/)
    end

    describe "searching" do
      before do
        visit cases_path

        # make sure all cases are being shown
        expect(page).to have_selector("td", text: "1284CV00125")

        # make sure all cases are filtered out
        fill_in "Search", with: "asljdfk"
        expect(page).to_not have_selector("td", text: "1284CV00125")
      end

      it "finds by partial case #" do
        fill_in "Search", with: "0125"
        expect(page).to have_selector("td", text: "1284CV00125")
      end

      it "finds by court name" do
        fill_in "Search", with: "Superior"
        expect(page).to have_selector("td", text: "1284CV00125")
      end

      it "finds by vehicle" do
        fill_in "Search", with: "Neon"
        expect(page).to have_selector("td", text: "1284CV00125")
      end
    end
  end

  describe "show" do
    before { driven_by(:rack_test) }
    it "should display the case" do
      visit case_path(caze)
      expect(page).to have_content("1284CV00125")
      expect(page).to have_content("Superior Court")
      expect(page).to have_content("$42.23")
      expect(page).to have_content("Nov 20, 2012")
      expect(page).to have_content("2004 Dodge Neon")
      expect(page).to have_link("123", href: /incidents\/42/)
    end
  end
end
