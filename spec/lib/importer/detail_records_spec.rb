describe Importer::DetailRecords do
  let(:record) {{
    :rowid=>"689917",
    :tracking_no=>"2125773",
    :emp_no=>"011359",
    :emp_name=>"KIRK,JAMES T",
    :emp_rank=>"06",
    :customer_no=>"00099089",
    :customer_name=>"Lewis Tree Service",
    :street_no=>"42",
    :street=>"CANTERBURY ST",
    :xstreet=>"WALK HILL ST",
    :start_date=>"3-Jul-19",
    :start_time=>"0830",
    :end_date=>"3-Jul-19",
    :end_time=>"1400",
    :hours_worked=>"0530",
    :detail_type=>"C",
    :pay_hours=>"8",
    :pay_amount=>"424",
    :pay_rate=>"53"
  }}
  let(:records) { [record] }
  let(:parser) { mock_parser(records) }
  let(:importer) { Importer::DetailRecords.new(parser) }
  let!(:officer) { Officer.create!(employee_id: 11359) }

  it "imports a record" do
    importer.import
    d = Detail.first
    expect(d.tracking_no).to eql(2125773)
    expect(d.employee_number).to eql(11359)
    expect(d.employee_name).to eql("KIRK,JAMES T")
    expect(d.employee_rank).to eql(6)
    expect(d.customer_number).to eql(99089)
    expect(d.customer_name).to eql("Lewis Tree Service")
    expect(d.street_no).to eql("42")
    expect(d.street).to eql("CANTERBURY ST")
    expect(d.xstreet).to eql("WALK HILL ST")
    expect(d.start_date_time).to eql("2019-07-03 08:30:00")
    expect(d.end_date_time).to eql("2019-07-03 14:00:00")
    expect(d.minutes_worked).to eql(330)
    expect(d.detail_type).to eql("C")
    expect(d.pay_hours).to eql(8)
    expect(d.pay_amount).to eql(424)
    expect(d.pay_rate).to eql(53)
    expect(d.attributions.first.category).to eql("b")
    expect(d.officer).to eql(officer)
  end

  it "doesn't import record twice" do
    importer.import
    importer.import
    expect(Detail.count).to eql(1)
  end
end
