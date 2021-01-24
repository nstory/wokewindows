describe Appeal do
  describe "#spr" do
    it "returns spr number" do
      expect(Appeal.new(case_no: "20200331").spr).to eql("SPR20/0331")
    end
  end
end
