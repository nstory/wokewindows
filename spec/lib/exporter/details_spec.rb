describe Exporter::Details do
  include_context "exporter"
  let!(:detail_kirk) { create(:detail_kirk) }

  it "exports" do
    export
    expect(record["tracking_no"]).to eql("6502")
    expect(record["employee_number"]).to eql("1701")
    expect(record["employee_name"]).to eql("Jim Kirk")
    expect(record["employee_rank"]).to eql("3")
    expect(record["customer_number"]).to eql("42")
    expect(record["customer_name"]).to eql("Utopia Planitia")
    expect(record["street_no"]).to eql("23")
    expect(record["street"]).to eql("Elm")
    expect(record["xstreet"]).to eql("Main")
    expect(record["start_date_time"]).to eql("2019-07-01 08:30:00")
    expect(record["end_date_time"]).to eql("2019-07-01 14:30:00")
    expect(record["minutes_worked"]).to eql("360")
    expect(record["detail_type"]).to eql("C")
    expect(record["pay_hours"]).to eql("8")
    expect(record["pay_amount"]).to eql("368.00")
    expect(record["pay_rate"]).to eql("46.00")
    expect(record["latitude"]).to eql("42.23")
    expect(record["longitude"]).to eql("23.42")
    expect(record["officer_employee_id"]).to eql("1701")
  end
end
