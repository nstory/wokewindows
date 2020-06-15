describe Populater::OfficerHrNames do
  it "populates hard-coded name" do
    o = Officer.create({employee_id: 153083})
    Populater::OfficerHrNames.populate
    expect(o.reload.hr_name).to eql("Harrington,Brian Ford")
  end

  it "populates an hr_name" do
    Compensation.create({year: 2019, name: "Rofl,Lol"})
    o = Officer.create({employee_id: 4242, journal_name: "LOL ROFL"})
    Populater::OfficerHrNames.populate
    expect(o.reload.hr_name).to eql("Rofl,Lol")
  end

  it "bails if matches multiple officers" do
    Compensation.create({year: 2019, name: "Rofl,Lol"})
    Compensation.create({year: 2019, name: "Rofl,Lol P"})
    o = Officer.create({employee_id: 4242, journal_name: "LOL ROFL"})
    Populater::OfficerHrNames.populate
    expect(o.reload.hr_name).to eql(nil)
  end

    it "matches FREDDIE J. VELEZ" do
      Compensation.create({year: 2019, name: "Velez,Freddie J."})
      o = Officer.create({employee_id: 4242, journal_name: "FREDDIE J. VELEZ"})
      Populater::OfficerHrNames.populate
      expect(o.reload.hr_name).to eql("Velez,Freddie J.")
    end

    it "matches AZADI CHARLES-SAMPSON" do
      Compensation.create({year: 2019, name: "Charles-Sampson,Azadi"})
      o = Officer.create({employee_id: 4242, journal_name: "AZADI CHARLES-SAMPSON"})
      Populater::OfficerHrNames.populate
      expect(o.reload.hr_name).to eql("Charles-Sampson,Azadi")
    end
end
