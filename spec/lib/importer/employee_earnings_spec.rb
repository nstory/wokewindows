describe Importer::EmployeeEarnings do
  include_context "importer"

  let(:record) {{
    :employee_id=>"1701",
    :name=>"Kirk,James T.",
    :department_name=>"Boston Police Department",
    :title=>"Police Officer",
    :regular=>"$56517.90",
    :retro=>"$0.00",
    :other=>"$800.00",
    :overtime=>"$17098.66",
    :injured=>"$13183.30",
    :detail=>"$28994.00",
    :quinn=>"$6970.34",
    :total_earnings=>"$123564.20",
    :postal=>"02124-5843",
    :filename=>"input/employee-earnings-report-2012.csv",
    :year=>"2012"
  }}

  let!(:officer_kirk) { create(:officer_kirk) }

  it "imports a record" do
    importer.import
    expect(Compensation.count).to eql(1)
    comp = Compensation.first
    expect(comp.name).to eql("Kirk,James T.")
    expect(comp.department_name).to eql("Boston Police Department")
    expect(comp.title).to eql("Police Officer")
    expect(comp.regular).to eql(56517.90)
    expect(comp.retro).to eql(0)
    expect(comp.other).to eql(800)
    expect(comp.overtime).to eql(17098.66)
    expect(comp.injured).to eql(13183.30)
    expect(comp.detail).to eql(28994.00)
    expect(comp.quinn).to eql(6970.34)
    expect(comp.total).to eql(123564.20)
    expect(comp.postal).to eql(2124)
    expect(comp.year).to eql(2012)
    expect(comp.attributions).to eql([attribution])
    expect(comp.officer).to eql(officer_kirk)
  end

  it "doesn't import non-BPD records" do
    record[:department_name] = "Foobar"
    importer.import
    expect(Compensation.count).to eql(0)
  end
end
