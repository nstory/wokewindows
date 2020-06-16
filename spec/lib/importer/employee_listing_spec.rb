describe Importer::EmployeeListing do
  let(:record) {{
    :empl_id=>"008511",
    :name=>"Evans,William B",
    :rank=>"Comiss",
    :badge=>"PC",
    :doa=>"11/1/82",
    :title=>"Commissioner (Bpd)",
    :orgname=>"OFFICE OF POLICE COMMISSIONER",
    :status=>"A"
  }}

  it "imports a record" do
    Importer::EmployeeListing.import([record])
    officer = Officer.last
    expect(officer.employee_id).to eql(8511)
    expect(officer.hr_name).to eql("Evans,William B")
    expect(officer.doa).to eql("1982-11-01")
    expect(officer.badge).to eql("PC")
  end

  it "updates an existing record" do
    Officer.create(employee_id: 8511, hr_name: "Rofl,LOL")
    Importer::EmployeeListing.import([record])
    expect(Officer.count).to eql(1)
    expect(Officer.last.hr_name).to eql("Evans,William B")
  end

  it "records blank badge as nil" do
    record[:badge] = ""
    Importer::EmployeeListing.import([record])
    expect(Officer.last.badge).to eql(nil)
  end
end
