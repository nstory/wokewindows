describe Populater::Officers do
  let!(:officer) {
    Officer.create!({ employee_id: 42 })
  }

  let!(:no_rank_officer) {
    Officer.create!({ employee_id: 43 })
  }

  let!(:third_rank_officer) {
    Officer.create!({ employee_id: 44, total: 6 })
  }

  let!(:first_rank_officer) {
    Officer.create!({ employee_id: 45, total: 9 })
  }

  let!(:compensation_2017) {
    Compensation.create!({
      "officer" => officer,
      "name"=>"Kirk,James T.",
      "title"=>"2017 title",
      "regular"=> 4242,
      "retro"=> 4242,
      "other"=> 4242,
      "overtime"=> 4242,
      "injured"=> 4242,
      "detail"=> 4242,
      "quinn"=> 4242,
      "total"=> 4242,
      "postal"=>4242,
      "year"=> 2017
    })
  }

  let!(:compensation_2019) {
    Compensation.create!({
      "officer" => officer,
      "name"=>"Kirk,James T.",
      "title"=>"2019 title",
      "regular"=> 1,
      "retro"=> 2,
      "other"=> 3,
      "overtime"=> 4,
      "injured"=> 5,
      "detail"=> 6,
      "quinn"=> 7,
      "total"=> 8,
      "postal"=> 12019,
      "year"=> 2019
    })
  }

  let!(:compensation_2018) {
    Compensation.create!({
      "officer" => officer,
      "name"=>"Kirk,James T.",
      "title"=>"2018 title",
      "regular"=> 4242,
      "retro"=> 4242,
      "other"=> 4242,
      "overtime"=> 4242,
      "injured"=> 4242,
      "detail"=> 4242,
      "quinn"=> 4242,
      "total"=> 4242,
      "postal"=>4242,
      "year"=> 2018
    })
  }

  let!(:complaint) {
    Complaint.create!({
      complaint_officers: [
        ComplaintOfficer.new(officer: officer)
      ]
    })
  }

  it "populates based on 2019 compensation" do
    Populater::Officers.populate
    officer.reload
    expect(officer.title).to eql("2019 title")
    expect(officer.regular).to eql(1)
    expect(officer.retro).to eql(2)
    expect(officer.other).to eql(3)
    expect(officer.overtime).to eql(4)
    expect(officer.injured).to eql(5)
    expect(officer.detail).to eql(6)
    expect(officer.quinn).to eql(7)
    expect(officer.total).to eql(8)
    expect(officer.postal).to eql(12019)
    expect(officer.complaints_count).to eql(1)

    first_rank_officer.reload
    third_rank_officer.reload
    no_rank_officer.reload
    expect(officer.earnings_rank).to eql(2)
    expect(first_rank_officer.earnings_rank).to eql(1)
    expect(third_rank_officer.earnings_rank).to eql(3)
    expect(no_rank_officer.earnings_rank).to be_nil
  end
end
