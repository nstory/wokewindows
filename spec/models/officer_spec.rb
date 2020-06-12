describe Officer do
  describe ".import_from_journal_records" do
    it "imports an officer" do
      Officer.import_from_journal_records([
        {officer: "054584  BRIAN ARMSTRONG"}
      ])
      expect(Officer.find_by(employee_id: 54584).journal_name).to eql("BRIAN ARMSTRONG")
    end

    it "doesn't import an officer twice" do
      2.times do
        Officer.import_from_journal_records([
          {officer: "054584  BRIAN ARMSTRONG"}
        ])
      end
      expect(Officer.count).to eql(1)
    end

    it "adds a journal_name if one doesn't exist" do
      Officer.create({employee_id: 4242})
      Officer.import_from_journal_records([
        {officer: "4242  ROFL LOL"}
      ])
      expect(Officer.count).to eql(1)
      expect(Officer.first.journal_name).to eql("ROFL LOL")
    end

    it "it doesn't import a non-numeric id" do
      Officer.import_from_journal_records([
        {officer: "4242L  BRIAN ARMSTRONG"}
      ])
      expect(Officer.count).to eql(0)
    end

    it "chooses most popular if multiple names with same id" do
      Officer.import_from_journal_records([
        {officer: "4242  LOL ROFL"},
        {officer: "4242  MOST POPULAR"},
        {officer: "4242  MOST POPULAR"},
        {officer: "4242  MOST POPULAR"},
        {officer: "4242  LOL ROFL"}
      ])
      expect(Officer.find_by(employee_id: 4242).journal_name).to eql("MOST POPULAR")
    end
  end

  describe ".import_from_bpd_annual_earnings" do
    it "imports an officer" do
      Officer.import_from_bpd_annual_earnings([
        {name: "Clown,Bozo F", empl_id: "04242"}
      ])
      expect(Officer.find_by(employee_id: 4242).hr_name).to eql("Clown,Bozo F")
    end
  end

  describe ".import_from_alpha_listing" do
    it "imports an officer" do
      Officer.import_from_alpha_listing([
        {name: "Clown,Bozo F", idno6: "04242", badge: "00591", doa: "11/24/82"}
      ])
      o = Officer.find_by(employee_id: 4242)
      expect(o.hr_name).to eql("Clown,Bozo F")
      expect(o.doa).to eql("1982-11-24")
    end
  end

  describe ".populate_hr_names_using_compensations" do
    it "populates an hr_name" do
      Compensation.create({year: 2019, name: "Rofl,Lol"})
      o = Officer.create({employee_id: 4242, journal_name: "LOL ROFL"})
      Officer.populate_hr_names_using_compensations
      expect(o.reload.hr_name).to eql("Rofl,Lol")
    end

    it "bails if name matches multiple officers" do
      Compensation.create({year: 2019, name: "Rofl,Lol"})
      Compensation.create({year: 2019, name: "Rofl,Lol"})
      o = Officer.create({employee_id: 4242, journal_name: "LOL ROFL"})
      Officer.populate_hr_names_using_compensations
      expect(o.reload.hr_name).to eql(nil)
    end

    it "matches FREDDIE J. VELEZ" do
      Compensation.create({year: 2019, name: "Velez,Freddie J."})
      o = Officer.create({employee_id: 4242, journal_name: "FREDDIE J. VELEZ"})
      Officer.populate_hr_names_using_compensations
      expect(o.reload.hr_name).to eql("Velez,Freddie J.")
    end
  end

  describe ".populate_compensations" do
    it "matches by name" do
      c = Compensation.create({year: 2019, name: "Lol,Rofl"})
      o = Officer.create({employee_id: 4242, hr_name: "Lol,Rofl"})
      Officer.populate_compensations
      expect(o.compensations.to_a).to eql([c])
    end

    it "doesn't match if multiple officers match" do
      Compensation.create({year: 2019, name: "Lol,Rofl"})
      o1 = Officer.create({employee_id: 4242, hr_name: "Lol,Rofl"})
      o2 = Officer.create({employee_id: 4243, hr_name: "Lol,Rofl"})
      Officer.populate_compensations
      expect(o1.compensations.to_a).to eql([])
      expect(o2.compensations.to_a).to eql([])
    end

    it "doesn't match if multiple compensations in same year match" do
      Compensation.create({year: 2019, name: "Lol,Rofl"})
      Compensation.create({year: 2019, name: "Lol,Rofl"})
      o = Officer.create({employee_id: 4242, hr_name: "Lol,Rofl"})
      Officer.populate_compensations
      expect(o.compensations.to_a).to eql([])
    end
  end

  describe ".rotated_likes" do
    it 'rotates' do
      rot = Officer.rotated_likes("A B")
      expect(rot).to eql(["B%A%"])
    end

    it 'rotates some more' do
      rot = Officer.rotated_likes("A B C")
      expect(rot).to eql(["B%C%A%","C%A%B%"])
    end
  end
end
