describe Officer do
  describe "#name" do
    it "returns hr_name" do
      expect(Officer.new({hr_name: "Foo,Bar P"}).name).to eql("Foo, Bar P")
    end

    it "returns journal_name if hr_name is not present" do
      expect(Officer.new({journal_name: "FOO BAR"}).name).to eql("Foo Bar")
    end

    it "otherwise Unknown" do
      expect(Officer.new({}).name).to eql("Unknown")
    end
  end

  describe ".by_employee_id" do
    it "returns a hash of officers" do
      o1 = Officer.create({employee_id: 1234})
      o2 = Officer.create({employee_id: 4567})
      expect(Officer.by_employee_id).to eql({
        1234 => o1,
        4567 => o2
      })
    end
  end
end
