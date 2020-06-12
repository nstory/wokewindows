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
      Officer.create({employee_id: 42})
      Officer.import_from_journal_records([
        {officer: "42  ROFL LOL"}
      ])
      expect(Officer.count).to eql(1)
      expect(Officer.first.journal_name).to eql("ROFL LOL")
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
end
