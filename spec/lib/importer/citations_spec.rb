describe Importer::Citations do
  let(:ticket_record) {{
    :issuing_agency=>"Boston Police District E-13",
    :ticket_num=>"T1189979",
    :type=>"CIVIL",
    :source=>"POLICE",
    :violator_type=>"OPERATOR",
    :cdl=>"No",
    :class=>"D",
    :event_date=>"2019-01-16 00:00:00.000",
    :time_hh=>"1",
    :time_mm=>"16",
    :am_pm=>"PM",
    :location_id=>"916",
    :location_name=>"W Roxbury",
    :offense=>"9011A0",
    :offense_description=>"LICENSE NOT IN POSSESSION * c90 11",
    :posted_speed=>"0",
    :violation_speed=>"0",
    :posted=>"",
    :radar=>"",
    :clocked=>"",
    :assessment=>"40.00",
    :expected_assessmnt=>"35.00",
    :display_assessmnt=>"40.00",
    :disposition=>"",
    :diposition_desc=>"",
    :criminial=>"",
    :major_indc=>"N",
    :sdip_points=>"0",
    :surchargeable=>"N",
    :race=>"HISP",
    :sex=>"MALE",
    :vehicle_color=>"GRAY",
    :make=>"ACURA TL",
    :model_yr=>"2010",
    :"16_pass"=>"NO",
    :haz_mat=>"NO",
    :amount=>"185.00",
    :paid=>"Y",
    :court_code=>"CT_006",
    :age=>"22",
    :searched=>"N",
    :officer_id=>"148270"
  }}

  let(:officer_record) {{
    :issuing_agency=>"Boston Police District E-13",
    :officer_id=>"148270",
    :type=>"CIVIL",
    :source=>"Court",
    :violator_type=>"OPERATOR",
    :cdl=>"No",
    :class=>"D",
    :event_date=>"2019-01-16 00:00:00.000",
    :time_hh=>"1",
    :time_mm=>"16",
    :am_pm=>"PM",
    :location_id=>"916",
    :location_name=>"W Roxbury",
    :offense=>"9011A0",
    :offense_description=>"LICENSE NOT IN POSSESSION * c90 11",
    :posted_speed=>"0",
    :violation_speed=>"0",
    :posted=>"",
    :radar=>"",
    :clocked=>"",
    :assessment=>"0.00",
    :expected_assessmnt=>"35.00",
    :display_assessmnt=>"0.00",
    :disposition=>"NR",
    :diposition_desc=>"Not Responsible",
    :criminial=>"",
    :major_indc=>"N",
    :sdip_points=>"0",
    :surchargeable=>"N",
    :race=>"HISP",
    :sex=>"MALE",
    :vehicle_color=>"GRAY",
    :make=>"ACURA TL",
    :model_yr=>"2010",
    :"16_pass"=>"NO",
    :haz_mat=>"NO",
    :amount=>"0.00",
    :paid=>"Y",
    :hearing_requested=>"Y",
    :court_code=>"CT_006",
    :age=>"22",
    :searched=>"N"
  }}

  let(:officer_speeding_record) do
    r = officer_record.dup
    r[:posted_speed] = 23
    r[:violation_speed] = 42
    r[:posted] = "YES"
    r[:radar] = "RADAR"
    r[:clocked] = "EST"
    r
  end

  let(:ticket_records) { [ticket_record] }
  let(:ticket_parser) { mock_parser(ticket_records) }
  let(:officer_records) { [officer_record] }
  let(:officer_parser) { mock_parser(officer_records) }
  let(:importer) { Importer::Citations.new(ticket_parser, officer_parser) }
  let!(:officer) { Officer.create(employee_id: 148270) }
  let(:citation) { Citation.first }

  it "imports a record" do
    importer.import
    expect(citation.officer).to eql(officer)
    expect(citation.issuing_agency).to eql("Boston Police District E-13")
    expect(citation.ticket_number).to eq("T1189979")
    expect(citation.officer_number).to eql(148270)
    expect(citation.ticket_type).to eql("CIVIL")
    expect(citation.source).to eql("Court")
    expect(citation.violator_type).to eql("OPERATOR")
    expect(citation.cdl).to eql(false)
    expect(citation.license_class).to eql("D")
    expect(citation.event_date).to eql("2019-01-16 13:16:00")
    expect(citation.location_id).to eql(916)
    expect(citation.location_name).to eql("W Roxbury")
    expect(citation.posted_speed).to eql(nil)
    expect(citation.violation_speed).to eql(nil)
    expect(citation.posted).to eql(nil)
    expect(citation.radar).to eql(nil)
    expect(citation.clocked).to eql(nil)
    expect(citation.race).to eql("HISP")
    expect(citation.sex).to eql("MALE")
    expect(citation.vehicle_color).to eql("GRAY")
    expect(citation.make).to eql("ACURA TL")
    expect(citation.model_year).to eql(2010)
    expect(citation.sixteen_pass).to eql(false)
    expect(citation.haz_mat).to eql(false)
    expect(citation.amount).to eql(0)
    expect(citation.paid).to eql(true)
    expect(citation.hearing_requested).to eql(true)
    expect(citation.court_code).to eql("CT_006")
    expect(citation.age).to eql(22)
    expect(citation.searched).to eql(false)
    expect(citation.attributions.first.category).to eql("b")
    offense = citation.offenses.first
    expect(offense.offense).to eql("9011A0")
    expect(offense.description).to eql("LICENSE NOT IN POSSESSION * c90 11")
    expect(offense.assessment).to eql(0.0)
    expect(offense.expected_assessment).to eql(35.0)
    expect(offense.display_assessment).to eql(0.0)
    expect(offense.disposition).to eql("NR")
    expect(offense.disposition_description).to eql("Not Responsible")
    expect(offense.major_incident).to eql(false)
    expect(offense.surchargeable).to eql(false)
    expect(offense.sdip_points).to eql(0)
  end

  it "imports a record with speeding fields" do
    officer_records[0] = officer_speeding_record
    importer.import
    expect(citation.posted_speed).to eql(23)
    expect(citation.violation_speed).to eql(42)
    expect(citation.posted).to eql(true)
    expect(citation.radar).to eql("RADAR")
    expect(citation.clocked).to eql("EST")
  end

  it "does not overwrite speeding fields with nils" do
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
