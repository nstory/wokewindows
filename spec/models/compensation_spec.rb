describe Compensation do
  let(:kervin_2019) {{
    :name=>"Kervin,Timothy M.",
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
    :postal=>"02135",
    :year=>2019
  }}

  describe ".import_earnings" do
    it "imports a 2019 record" do
      Compensation.import_earnings([kervin_2019])
      expect(Compensation.count).to eql(1)
      comp = Compensation.first
      expect(comp.name).to eql("Kervin,Timothy M.")
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
      expect(comp.year).to eql(2019)
    end

    it "does not import non-BPD records" do
      kervin_2019[:department] = "Foobar"
      Compensation.import_earnings([kervin_2019])
      expect(Compensation.count).to eql(0)
    end
  end
end
