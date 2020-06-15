describe Populater::Compensations do
  it "associates a compensation" do
    c = Compensation.create({year: 2019, name: "Lol,Rofl"})
    o = Officer.create({employee_id: 4242, hr_name: "Lol,Rofl"})
    Populater::Compensations.populate
    expect(o.compensations.to_a).to eql([c])
  end

  it "doesn't if multiple officers match" do
    c = Compensation.create({year: 2019, name: "Lol,Rofl"})
    o1 = Officer.create({employee_id: 4242, hr_name: "Lol,Rofl"})
    o2 = Officer.create({employee_id: 4243, hr_name: "Lol,Rofl"})
    Populater::Compensations.populate
    expect(c.reload.officer).to eql(nil)
  end

  it "doesn't if multiple compensations in same year match" do
    Compensation.create({year: 2019, name: "Lol,Rofl"})
    Compensation.create({year: 2019, name: "Lol,Rofl"})
    o = Officer.create({employee_id: 4242, hr_name: "Lol,Rofl"})
    Populater::Compensations.populate
    expect(o.compensations.to_a).to eql([])
  end
end
