describe Parser::DistrictJournal do
  let(:parser) { Parser::DistrictJournal.new(file) }
  let(:records) { parser.records }
  let(:record_765) { find_record "202020765-00" }

  def find_record(complaint_number)
    records.find { |r| complaint_number== r[:complaint_number] }
  end

  describe "new style file" do
    let(:file) { file_fixture("district_journal.pdf") }
    it "parses" do
      # multiple tests in a single it-block so we don't repeatedly
      # parse the file
      expect(parser.record_count).to eql(90)
      expect(records.count).to eql(90)

      expect(records.first).to eql({
        report_date_time: "3/16/2020 12:00:06 AM",
        complaint_number: "202020768-00",
        location_of_occurrence: "",
        nature_of_incident: "M/V ACCIDENT - INVOLVING BICYCLE - INJURY",
        occurrence_date_time: "3/15/2020 11:02:00 PM",
        officer: "099790  SCOTT LUCAS",
        arrests: []
      })

      expect(records.last).to eql({
        complaint_number: "202020882-00",
        location_of_occurrence: "260 N BEACON ST",
        nature_of_incident: "INVESTIGATE PERSON",
        occurrence_date_time: "3/16/2020 1:06:00 PM",
        officer: "010513  ROGER BURKE",
        report_date_time: "3/16/2020 3:06:02 PM",
        arrests: []
      })

      expect(record_765[:arrests]).to eql([
        {name: "Crystal Capel", address: "65 MEDFORD MALDEN MA", charge: "DRUG, POSSESS TO DISTRIB CLASS B c94C.32A(a)"},
        {name: "Tyrone Kennedy", address: "12 ROGERS AVE LYNN MA", charge: "UNLICENSED OPERATION OF MV c90.10"}
      ])
    end
  end

  describe "old style file" do
    let(:file) { file_fixture("district_journal_alt_format.pdf") }
    let(:record_861) { find_record "182000861" }
    let(:record_906) { find_record "182000906" }

    it "parses" do
      expect(parser.record_count).to eql(202)
      expect(records.count).to eql(202)

      expect(records.first).to eql({
        complaint_number: "182000828",
        arrests: [],
        location_of_occurrence: "E5 - 940 VFW PKWY",
        nature_of_incident: "VERBAL DISPUTE",
        occurrence_date_time: "1/4/2018 12:12:00 AM",
        officer: "054584  BRIAN ARMSTRONG",
        report_date_time: "1/4/2018 12:12:00 AM"
      })

      expect(records.last).to eql({
        arrests: [],
        complaint_number: "182001039",
        location_of_occurrence: "C11 - 11 WAINWRIGHT ST",
        nature_of_incident: "SICK/INJURED/MEDICAL - PERSON",
        occurrence_date_time: "1/4/2018 11:10:00 PM",
        officer: "120908  RICHARD MULLALY",
        report_date_time: "1/4/2018 11:10:00 PM"
      })

      expect(record_861[:arrests]).to eql([
        {name: "MCCADDEN, KARLA", address: "200 LEXINGTON ST   BSTN, MA", charge: "Assault - Assault & Battery, Dangerous Weapon - Knife"},
        {name: "MCCADDEN, KARLA", address: "200 LEXINGTON ST   BSTN, MA", charge: "Drug Possession - Possession of Class E"},
        {name: "MCCADDEN, KARLA", address: "200 LEXINGTON ST   BSTN, MA", charge: "Drug Possession - Possession of Class B"}
      ])

      # record has non-ascii in nature_of_incident that should be stripped
      expect(record_906[:nature_of_incident]).to eql("M/V ACCIDENT - PROPERTY DAMAGE")
    end
  end

  describe "alternate file format with split" do
    let(:file) { file_fixture("district_journal_alt_format_with_split.pdf") }
    let(:record_643) { find_record "192033643" }

    it "parses record split over page 1 and 2 correctly" do
      expect(record_643[:location_of_occurrence]).to eql("C6 - 1080 MASSACHUSETTS AVE")
      expect(record_643[:officer]).to eql("148246  JOANNE BYRNE")
    end
  end

  describe "new format file with split" do
    let(:file) { file_fixture("district_journal_split.pdf") }
    let(:record_100) { find_record "192090100-00" }

    it "parses split record correctly" do
      expect(record_100[:officer]).to eql("012209  RICO LUCIEN")
      expect(record_100[:location_of_occurrence]).to eql("1415 HYDE PARK AVE")
    end
  end
end
