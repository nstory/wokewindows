describe Importer::Citations do
  include_context "importer"

  let(:record) {{
    :issuing_agency=>"Boston Police Area L",
    :agency_code=>"PD_666",
    :officer_id=>"93863",
    :officer_name=>"Roberts,Shawn",
    :event_date=>"2011-02-12 00:00:00.000",
    :time_hh=>"12",
    :time_mm=>"09",
    :am_pm=>"AM",
    :violator_type=>"OPERATOR",
    :ticket_num=>"R0530441",
    :type=>"CRIM",
    :offense=>"9017A2",
    :offense_description=>"SPEEDING * c90 17",
    :disposition=>"NR",
    :disposition_desc=>"Not Responsible",
    :location_name=>"W Roxbury",
    :searched=>"N",
    :crash_=>"Y",
    :court_code=>"CT_006",
    :race=>"BLACK",
    :sex=>"MALE",
    :year_of_birth=>"1981",
    :lic_state=>"MA",
    :class=>"D",
    :cdl=>"No",
    :platetype=>"PAN",
    :vhc_state=>"MA",
    :model_yr=>"2010",
    :make=>"LINCOLN MKS",
    :commercial=>"No",
    :vehicle_color=>"GRAY",
    :"16_pass"=>"Unk",
    :haz_mat=>"No",
    :amount=>"0.00",
    :paid=>"N",
    :hearing_requested=>"N",
    :speed=>"1",
    :posted_speed=>"0",
    :violation_speed=>"0",
    :posted=>"UNK",
    :radar=>"UNK",
    :clocked=>"UNK",
    :officer_cert=>"VIOL"
  }}

  # let(:ticket_records) { [ticket_record] }
  # let(:ticket_parser) { mock_parser(ticket_records) }
  # let(:officer_records) { [officer_record] }
  # let(:officer_parser) { mock_parser(officer_records) }
  # let(:importer) { Importer::Citations.new(ticket_parser, officer_parser) }
  let!(:officer) { Officer.create(employee_id: 93863) }
  let(:citation) { Citation.first }

  it "imports a record" do
    importer.import
    expect(citation.officer).to eql(officer)
    expect(citation.issuing_agency).to eql("Boston Police Area L")
    expect(citation.ticket_number).to eq("R0530441")
    expect(citation.officer_number).to eql(93863)
    expect(citation.ticket_type).to eql("CRIM")
    # expect(citation.source).to eql("Court")
    expect(citation.violator_type).to eql("OPERATOR")
    expect(citation.cdl).to eql(false)
    expect(citation.license_class).to eql("D")
    expect(citation.event_date).to eql("2011-02-12 00:09:00")
    # expect(citation.location_id).to eql(916)
    expect(citation.location_name).to eql("W Roxbury")
    expect(citation.posted_speed).to eql(nil)
    expect(citation.violation_speed).to eql(nil)
    expect(citation.posted).to eql(nil)
    expect(citation.radar).to eql("UNK")
    expect(citation.clocked).to eql("UNK")
    expect(citation.race).to eql("BLACK")
    expect(citation.sex).to eql("MALE")
    expect(citation.vehicle_color).to eql("GRAY")
    expect(citation.make).to eql("LINCOLN MKS")
    expect(citation.model_year).to eql(2010)
    expect(citation.sixteen_pass).to eql(nil)
    expect(citation.haz_mat).to eql(false)
    expect(citation.amount).to eql(0)
    expect(citation.paid).to eql(false)
    expect(citation.hearing_requested).to eql(false)
    expect(citation.court_code).to eql("CT_006")
    # expect(citation.age).to eql(22)
    expect(citation.searched).to eql(false)
    expect(citation.attributions.first.category).to eql("b")
    offense = citation.offenses.first
    expect(offense.offense).to eql("9017A2")
    expect(offense.description).to eql("SPEEDING * c90 17")
    # expect(offense.assessment).to eql(0.0)
    # expect(offense.expected_assessment).to eql(35.0)
    # expect(offense.display_assessment).to eql(0.0)
    expect(offense.disposition).to eql("NR")
    expect(offense.disposition_description).to eql("Not Responsible")
    # expect(offense.major_incident).to eql(false)
    # expect(offense.surchargeable).to eql(false)
    # expect(offense.sdip_points).to eql(0)
  end

  it "does not import a record w/o a ticket number" do
    record[:ticket_num] = ""
    importer.import
    expect(Citation.count).to eql(0)
  end

  xit "imports a record with speeding fields" do
    officer_records[0] = officer_speeding_record
    importer.import
    expect(citation.posted_speed).to eql(23)
    expect(citation.violation_speed).to eql(42)
    expect(citation.posted).to eql(true)
    expect(citation.radar).to eql("RADAR")
    expect(citation.clocked).to eql("EST")
  end

  xit "does not overwrite speeding fields with nils" do
    officer_records[0] = officer_speeding_record
    importer.import
    officer_records[0] = officer_record
    importer.import
    expect(citation.posted_speed).to eql(23)
    expect(citation.violation_speed).to eql(42)
    expect(citation.posted).to eql(true)
    expect(citation.radar).to eql("RADAR")
    expect(citation.clocked).to eql("EST")
  end
end
