describe Importer::BostonRetirementSystem do
  include_context "importer"

  let(:record) {{
    :sort_name=>"KIRK, JAMES T",
    :gross_amount=>"7531.77",
    :retirement_date=>"5-Jul-20",
    :department=>"BOSTON POLICE DEPARTMENT - 211000",
    :job_description=>"Starship Captain - 311251"
  }}

  let!(:officer_kirk) { create(:officer_kirk, active: false) }

  it "imports record" do
    importer.import
    p = Pension.first
    expect(p.name).to eql("KIRK, JAMES T")
    expect(p.amount).to eql(7531.77)
    expect(p.retirement_date).to eql("2020-07-05")
    expect(p.department).to eql("BOSTON POLICE DEPARTMENT - 211000")
    expect(p.job_description).to eql("Starship Captain - 311251")
    expect(p.officer).to eql(officer_kirk)
    expect(officer_kirk.pension).to eql(p)
    expect(p.attributions).to eql([attribution])
  end

  it "skips if job_description don't match" do
    record[:job_description] = "Foobar - 311251"
    importer.import
    expect(Pension.first.officer).to eql(nil)
  end

  it "skips non-BPD" do
    record[:department] = "Xyzzy"
    importer.import
    expect(Pension.count).to eql(0)
  end

  it "doesn't connect to active officer" do
    officer_kirk.active = true
    officer_kirk.save
    importer.import
    expect(Pension.first.officer).to eql(nil)
  end
end
