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
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: nil }
  let(:parser) { mock_parser(records, attribution) }
  let(:set_active) { false }
  let(:importer) { Importer::EmployeeListing.new(parser, set_active) }

  it "imports a record" do
    importer.import
    officer = Officer.last
    expect(officer.employee_id).to eql(8511)
    expect(officer.hr_name).to eql("Evans,William B")
    expect(officer.doa).to eql("1982-11-01")
    expect(officer.badge).to eql("PC")
    expect(officer.attributions).to eql([attribution])
  end

  it "updates an existing record" do
    Officer.create(employee_id: 8511, hr_name: "Rofl,LOL")
    importer.import
    expect(Officer.count).to eql(1)
    expect(Officer.last.hr_name).to eql("Evans,William B")
  end

  it "records blank badge as nil" do
    record[:badge] = ""
    importer.import
    expect(Officer.last.badge).to eql(nil)
  end

  it "doesn't nil field that's already populated" do
    officer = Officer.create(employee_id: 8511, badge: "LOL")
    record[:badge] = ""
    importer.import
    expect(officer.reload.badge).to eql("LOL")
  end

  it "removes leading zeros from badge number" do
    record[:badge] = "0042"
    importer.import
    expect(Officer.last.badge).to eql("42")
  end

  describe "set_active=true" do
    let(:set_active) { true }
    it "sets active flag on existing record" do
      officer = Officer.create(employee_id: 8511, hr_name: "Rofl,LOL")
      importer.import
      expect(officer.reload.active).to eql(true)
    end
  end

  describe "2020 record" do
    let(:record) {{
      :empl_id=>"009018",
      :name=>"Gross,William G.",
      :percopy_rank=>"00",
      :rank_rank=>"Comiss",
      :orgcode=>"10000",
      :org_description=>"OFFICE OF POLICE COMMISSIONER",
      :title=>"Commissioner (Bpd)",
      :badge=>"SUPT",
      :status=>"A",
      :asof=>"7/15/20"
    }}

    it "imports the record" do
      importer.import
      officer = Officer.last
      expect(officer.rank).to eql("comiss")
      expect(officer.organization).to eql("OFFICE OF POLICE COMMISSIONER")
      expect(officer.title).to eql("Commissioner (Bpd)")
    end
  end

  describe "roster20200904 record" do
    let(:record) {{
      :name=>"Gross,William G.",
      :empl_id=>"009018",
      :start_date=>"8/10/83",
      :sex=>"M",
      :title=>"Commissioner (Bpd)",
      :org_description=>"Office Of Police Commissioner",
      :ethnic_grp=>"BLACK"
    }}

    it "imports the record" do
      importer.import
      officer = Officer.last
      expect(officer.start_date).to eql("1983-08-10")
      expect(officer.sex).to eql("M")
      expect(officer.ethnic_group).to eql("BLACK")
    end
  end
end
