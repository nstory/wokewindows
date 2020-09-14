describe DataSource do
  describe ".all" do
    it "does not include index" do
      ids = DataSource.all.pluck(:id)
      expect(ids).to_not include("index")
    end
  end

  describe ".find" do
    it "finds alpha_listing" do
      ds = DataSource.find("alpha_listing")
      expect(ds.id).to eql("alpha_listing")
    end
  end
end
