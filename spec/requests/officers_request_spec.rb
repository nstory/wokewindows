describe "Officers" do
  describe "datatable.csv" do
    let!(:officer) { Officer.create(employee_id: 123) }
    let!(:officer2) { Officer.create(employee_id: 456) }

    it "responds with csv" do
      post datatable_officers_path(format: "csv")
      expect(response.content_type).to eql("application/csv")
      expect(response.body).to match(/url,employee_id/)
      expect(response.body).to match(/officers\/123/)
      expect(response.body).to match(/officers\/456/)
    end
  end
end
