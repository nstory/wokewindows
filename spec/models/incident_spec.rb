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

  describe ".import_journals" do
    it "imports" do
      Incident.import_incident_reports([incident_report])
      Incident.import_journals([
        {
          complaint_number: "92102201",
          location_of_occurrence: "A1 - 101 BROAD ST",
          nature_of_incident: "ASSAULT SIMPLE - BATTERY",
        },
        {
          complaint_number: "92102201",
          location_of_occurrence: "lol",
          nature_of_incident: "ROFLCOPTER",
        },
      ])
      inc = Incident.first
      expect(inc.location_of_occurrence).to include("lol")
      expect(inc.location_of_occurrence).to include("A1 - 101 BROAD ST")
      expect(inc.nature_of_incident).to include("ASSAULT SIMPLE - BATTERY")
      expect(inc.nature_of_incident).to include("ROFLCOPTER")
    end

    it "imports officers" do
      inc = Incident.create(incident_number: "12345")
      Incident.import_journals([
        {
          complaint_number: "12345",
          officer: "042  JAMES KIRK"
        }
      ])
      inc.reload
      expect(inc.incident_officers.count).to eql(1)
      expect(inc.incident_officers.first.journal_officer).to eql("042  JAMES KIRK")
    end

    it "ignores blank officer field" do
      inc = Incident.create(incident_number: "12345")
      Incident.import_journals([
        {
          complaint_number: "12345",
          officer: "  "
        }
      ])
      inc.reload
      expect(inc.incident_officers.count).to eql(0)
    end

    it "imports arrests" do
      inc = Incident.create(incident_number: "182000830")
      Incident.import_journals([journal_entry])
      inc.reload
      expect(inc.arrests.first.name).to eql("MCCOY, BONES")
      expect(inc.arrests.first.charge).to eql("Assault - Assault & Battery")
    end
  end
end
