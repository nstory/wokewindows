describe Incident do
  let(:incident_report) {{
    incident_number: "I92102201",
    offense_code: "3301",
    offense_code_group: "ABC 123",
    offense_description: "VERBAL DISPUTE",
    district: "E13",
    reporting_area: "583",
    shooting: "0",
    occurred_on_date: "2019-12-20 03:08:00",
    year: "2019",
    month: "12",
    day_of_week: "Friday",
    hour: "3",
    ucr_part: "Xyzzy",
    street: "DAY ST",
    lat: "42.325122",
    long: "-71.107779",
    location: "(42.32512200, -71.10777900)"
  }}

  let(:journal_entry) {{
    :report_date_time=>"1/4/2018 12:21:00 AM",
    :complaint_number=>"182000830",
    :occurrence_date_time=>"1/4/2018 12:21:00 AM",
    :location_of_occurrence=>"A1 - 101 BROAD ST",
    :nature_of_incident=>"ASSAULT SIMPLE - BATTERY",
    :officer=>"042  JAMES KIRK",
    :arrests=>
    [{:name=>"MCCOY, BONES",
      :address=>"42 BOGUS ST   BSTN, MA",
      :charge=>"Assault - Assault & Battery"}]}
  }

  describe ".create_from_incident_reports_and_journal_entries" do
    it "creates from just incident" do
      inc = Incident.create_from_incident_reports_and_journal_entries([incident_report], [])
      expect(inc.incident_number).to eql("I92102201")
      expect(inc.district).to eql("E13")
      expect(inc.reporting_area).to eql(583)
      expect(inc.shooting).to eql(false)
      expect(inc.occurred_on_date).to eql("2019-12-20 03:08:00")
      expect(inc.ucr_part).to eql("Xyzzy")
      expect(inc.street).to eql("DAY ST")
      expect(inc.latitude).to eql(42.325122)
      expect(inc.longitude).to eql(-71.107779)

      off = inc.offenses.first
      expect(off.code).to eql(3301)
      expect(off.code_group).to eql("ABC 123")
      expect(off.description).to eql("VERBAL DISPUTE")
    end

    it "reporting area is blank" do
      incident_report[:reporting_area] = ""
      inc = Incident.create_from_incident_reports_and_journal_entries([incident_report], [])
      expect(inc.reporting_area).to eql(nil)
    end

    it "shooting=Y" do
      incident_report[:shooting] = "Y"
      inc = Incident.create_from_incident_reports_and_journal_entries([incident_report], [])
      expect(inc.shooting).to eql(true)
    end

    it "shooting=1" do
      incident_report[:shooting] = "1"
      inc = Incident.create_from_incident_reports_and_journal_entries([incident_report], [])
      expect(inc.shooting).to eql(true)
    end

    it "raise if incident report numbers differ" do
      expect {
        Incident.create_from_incident_reports_and_journal_entries(
          [{incident_number: "I123"}, {incident_number: "456"}],
          []
        )
      }.to raise_error(RuntimeError)
    end

    it "imports multiple offenses" do
      second_report = {
        incident_number: "I92102201",
        offsense_code: 42,
        offense_code_group: "lol",
        offense_description: "rofl"
      }
      inc = Incident.create_from_incident_reports_and_journal_entries(
        [incident_report, second_report], []
      )
      expect(inc.offenses.to_a.count).to eql(2)
    end

    it "combines with data from journal" do
      inc = Incident.create_from_incident_reports_and_journal_entries(
        [incident_report], [journal_entry]
      )
      expect(inc.location_of_occurrence).to eql(["A1 - 101 BROAD ST"])
      expect(inc.nature_of_incident).to eql(["ASSAULT SIMPLE - BATTERY"])
    end

    pending "raises if journal has different incident number"
  end
end
