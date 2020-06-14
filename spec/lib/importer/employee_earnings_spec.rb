describe Importer::EmployeeEarnings do
  let(:kirk_2019) {{
    :name=>"Kirk,James T.",
    :department=>"Boston Police Department",
    :title=>"Police Lieutenant/Hdq Dispatch",
    :regular=>"  142,061.86 ",
    :retro=>"  -   ",
    :other=>"  21,262.85 ",
    :overtime=>"  115,361.12 ",
    :injured=>"  -   ",
    :detail=>"  41,360.00 ",
    :quinn=>"  35,492.87 ",
    :total=>"355,538.70",
    :postal=>"02135"
  }}

  it "imports a record" do
    Importer::EmployeeEarnings.import(2001, [kirk_2019])
    expect(Compensation.count).to eql(1)
    comp = Compensation.first
    expect(comp.name).to eql("Kirk,James T.")
    expect(comp.department_name).to eql("Boston Police Department")
    expect(comp.title).to eql("Police Lieutenant/Hdq Dispatch")
    expect(comp.regular).to eql(142061.86)
    expect(comp.retro).to eql(0)
    expect(comp.other).to eql(21262.85)
    expect(comp.overtime).to eql(115361.12)
    expect(comp.injured).to eql(0)
    expect(comp.detail).to eql(41360.00)
    expect(comp.quinn).to eql(35492.87)
    expect(comp.total).to eql(355538.70)
    expect(comp.postal).to eql(2135)
    expect(comp.year).to eql(2001)
  end

  it "doesn't import non-BPD records" do
    kirk_2019[:department] = "Foobar"
    Importer::EmployeeEarnings.import(2019, [kirk_2019])
    expect(Compensation.count).to eql(0)
  end
end
