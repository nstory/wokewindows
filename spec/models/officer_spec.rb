describe Officer do
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
