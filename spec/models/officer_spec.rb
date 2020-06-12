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
end
